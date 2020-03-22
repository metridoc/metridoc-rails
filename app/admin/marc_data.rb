ActiveAdmin.register_page "MarcData" do
  menu if: proc{ authorized?(:read, "Marc") }, label: I18n.t("active_admin.marc_data"), parent: I18n.t("active_admin.resource_sharing")

  content title: proc{ I18n.t("active_admin.marc_data") } do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Marc::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
