ActiveAdmin.register_page "Ares",
namespace: :course_reserves do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('CourseReserves', :course_reserves_root)
    ]
  end

  content title: "CourseReserves::Ares" do
    resource_collection = ActiveAdmin.application.namespaces[:course_reserves].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Ares::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end

end
