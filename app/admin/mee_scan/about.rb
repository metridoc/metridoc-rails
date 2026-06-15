ActiveAdmin.register_page "About",
namespace: :mee_scan do

  menu false

  content title: "MeeScan" do
    resource_collection = ActiveAdmin.application.namespaces[:mee_scan].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select { |r| /^MeeScan::/.match(r.resource_name.name) }
    resources = resources.sort { |a, b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: { resources: resources }
  end

end
