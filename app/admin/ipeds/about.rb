ActiveAdmin.register_page "About", namespace: :ipeds do
  menu false
  # domain/ipeds and domain/ipeds/about are defined by this file.
  content title: I18n.t("active_admin.ipeds.ipeds_menu") do
    resource_collection = ActiveAdmin.application.namespaces[:ipeds].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Ipeds::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
