ActiveAdmin.register_page "Relais",
namespace: :borrowdirect do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root)
    ]
  end

  # Action need to get the redirect with parameters
  page_action :statistics, method: :post do
    redirect_to "/borrowdirect/relais_statistics?fiscal_year=#{params['fiscal_year']}&library_id=#{params['library_id']}"
  end

  content title: "BorrowDirect::Relais" do
    resource_collection = ActiveAdmin.application.namespaces[:borrowdirect].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Relais::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end

end
