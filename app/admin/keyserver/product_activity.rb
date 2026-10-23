ActiveAdmin.register_page "Product Activity",
namespace: :keyserver do
  menu false

  breadcrumb do
    [
      link_to('Keyserver', :keyserver_root),
    ]
  end

  controller do
    include Keyserver::Filterable

    def index
      setup_date_range(Keyserver::ProductUsage)
      setup_division_list

      result = Keyserver::ProductActivitySummary.new(
        filtered_scope(Keyserver::ProductUsage)
      ).call

      @product_summary = result[:product_summary]
      @unused_products = result[:unused_products]
    end
  end

  # General title for the page
  content title: "Product Activity" do
    # Direct path to dashboard template
    render partial: 'keyserver/analysis/product_activity'
  end
end