# app/services/keyserver/user_profile_summary.rb
module Keyserver
  class UserProfileSummary
    def initialize(product_scope:, program_scope:, session_scope:)
      @product_scope = product_scope
      @program_scope = program_scope
      @session_scope = session_scope
    end

    def call
      {
        product_usage: top_ten(@product_scope, :product_name),
        program_usage: top_ten(@program_scope, :program_name),
        sessions:      top_ten(@session_scope, :division)
      }
    end

    private

    def top_ten(scope, group_by)
      scope.group(group_by)
        .order("count_all DESC")
        .limit(10)
        .count
          #  .count
          #  .sort_by { |_, v| -v }
          #  .first(10)
          #  .to_h
    end
  end
end