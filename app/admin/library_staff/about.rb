ActiveAdmin.register_page "About",
namespace: :library_staff do

  menu false

  content title: "Library Staff" do
    resource_collection = ActiveAdmin.application.namespaces[:library_staff].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    puts resources.map{|r| r.resource_name.name}
    resources = resources.select{|r| /^::LibraryStaff::/.match(r.resource_class_name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
