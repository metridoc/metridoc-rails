ActiveAdmin.register_page "Borrowdirect" do
  menu false

  # Action need to get the redirect with parameters
  page_action :statistics, method: :post do
    redirect_to "/admin/borrowdirect_statistics?fiscal_year=#{params['fiscal_year']}&library_id=#{params['library_id']}"
  end

  content title: I18n.t("active_admin.borrowdirect.borrowdirect_menu") do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Borrowdirect::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end

  # Redefine ActiveAdmin::PageController::authorize_access
  # This will restrict the page view to the correct users.
  controller do
    private
    def authorize_access!
      authorize! :read, "Borrowdirect"
    end
  end

end
