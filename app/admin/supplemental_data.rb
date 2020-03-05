ActiveAdmin.register_page "SupplementalData" do
  menu if: proc{ authorized?(:read, "SupplementalData") }, parent: I18n.t("active_admin.resource_sharing")

  content title: proc{ I18n.t("active_admin.supplemental_data.supplemental_data_menu") } do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| r.resource_name.name.in?(["Institution", "UpsZone", "GeoData::ZipCode"]) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
