ActiveAdmin.register_page "Borrowdirect Reshare",
namespace: :borrowdirect do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root)
    ]
  end

  menu false

  content title: "BorrowDirect::ReShare" do
    resource_collection = ActiveAdmin.application.namespaces[:borrowdirect].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Reshare::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
