ActiveAdmin.register_page "SupplementalData" do
  menu false

  content title: proc{ I18n.t("active_admin.supplemental_data") } do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| r.resource_name.name.in?(["Institution", "UpsZone"]) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
