ActiveAdmin.register_page "Keyserver" do
  menu if: proc{ authorized?(:read, "Keyserver") }, label: I18n.t("active_admin.keyserver.keyserver_menu"), parent: I18n.t("active_admin.resource_sharing")

  content title: I18n.t("active_admin.keyserver.keyserver_menu") do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Keyserver::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end

  # Redefine ActiveAdmin::PageController::authorize_access
  # This will restrict the page view to the correct users.
  controller do
    private
    def authorize_access!
      authorize! :read, "Keyserver"
    end
  end

end
