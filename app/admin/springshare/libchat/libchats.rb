ActiveAdmin.register_page "Libchats",
namespace: :springshare do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root)
    ]
  end
  
  content title: I18n.t("Springshare::Libchats") do
    resource_collection = ActiveAdmin.application.namespaces[:springshare].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Libchats::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
  
end
