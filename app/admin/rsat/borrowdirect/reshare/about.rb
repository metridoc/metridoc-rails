ActiveAdmin.register_page "Borrowdirect Reshare",
namespace: :rsat do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('RSAT', :rsat_root),
      link_to('BorrowDirect', :rsat_borrowdirect)
    ]
  end

  menu false

  content title: "RSAT::BorrowDirect::ReShare" do
    resource_collection = ActiveAdmin.application.namespaces[:rsat].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Borrowdirect::Reshare::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
