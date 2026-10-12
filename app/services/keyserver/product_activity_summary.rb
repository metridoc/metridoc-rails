# app/services/keyserver/product_activity_summary.rb
module Keyserver
  class ProductActivitySummary
    def initialize(scope)
      @scope = scope
    end
    
    def call
      {
        product_summary: product_summary,
        unused_products: unused_products
      }
    end

    private
    
    def product_summary
      @scope
        .group(:product_name)
        .select(
          :product_name,
          "COUNT(DISTINCT user_name) AS unique_users", 
          "COUNT(DISTINCT computer_name) AS computers_used", 
          "COUNT(*) AS sessions", 
          "AVG(duration) AS avg_duration", 
          "MAX(install_count) AS install_count",
          "MAX(start_time) AS most_recent_use"
        )
        .order(:product_name)
        .to_a
    end

    def unused_products
      used_product_names = @scope.select(:product_name).distinct

      Keyserver::Product
        .where.not(product_name: used_product_names)
        .select(:product_name, :install_count)
        .order(:product_name)
    end
  end
end