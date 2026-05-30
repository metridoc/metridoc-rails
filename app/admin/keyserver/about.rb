ActiveAdmin.register_page "About", namespace: :keyserver do
  menu false

  content title: "Keyserver" do
    resource_collection = ActiveAdmin.application.namespaces[:keyserver].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select { |r| /^Keyserver::/.match(r.resource_name.name) }
    resources = resources.sort { |a, b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: { resources: resources }
  end
end
