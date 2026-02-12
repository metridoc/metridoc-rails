ActiveAdmin.register_page "About",
namespace: :caiasoft do

  menu false

  content title: "Caiasoft" do
    resource_collection = ActiveAdmin.application.namespaces[:caiasoft].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Caiasoft::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end

end
