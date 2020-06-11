ActiveAdmin.register_page "LibraryProfile" do
  menu if: proc{ authorized?(:read, "LibraryProfile") }, label: I18n.t("active_admin.library_profiles_heading"), parent: I18n.t("active_admin.resource_sharing")

  content title: proc{ I18n.t("active_admin.library_profiles_heading") } do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^LibraryProfile::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
