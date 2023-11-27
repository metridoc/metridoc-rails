ActiveAdmin.register_page "Universal Analytics",
namespace: :google_analytics do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Google Analytics', :google_analytics_root)
    ]
  end

  content title: "GoogleAnalytics::UniversalAnalytics" do
    resource_collection = ActiveAdmin.application.namespaces[:google_analytics].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^UniversalAnalytics::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }
    render partial: 'index', locals: {resources: resources}
  end

end
