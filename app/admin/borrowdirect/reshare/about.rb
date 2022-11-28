ActiveAdmin.register_page "Reshare",
namespace: :borrowdirect do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root)
    ]
  end

  menu false

  # Action need to get the redirect with parameters
  page_action :statistics, method: :post do
    redirect_to "/borrowdirect/reshare_statistics?fiscal_year=#{params['fiscal_year']}&institution=#{params['institution']}"
  end

  content title: "BorrowDirect::ReShare" do
    resource_collection = ActiveAdmin.application.namespaces[:borrowdirect].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Reshare::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
