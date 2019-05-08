ActiveAdmin.register_page "Misc" do
  menu false
  content title: proc{ I18n.t("active_admin.misc_heading") } do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| r.resource_name.name.in?(["Institution", "UpsZone", "GeoData::ZipCode"]) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
