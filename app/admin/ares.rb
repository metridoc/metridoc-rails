ActiveAdmin.register_page "Ares" do
  menu if: proc{ authorized?(:read, "Ares") }, label: I18n.t("active_admin.ares.ares_menu"), parent: I18n.t("active_admin.resource_sharing")

  content title: I18n.t("active_admin.ares.ares_menu") do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Ares::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
