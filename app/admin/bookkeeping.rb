ActiveAdmin.register_page "Bookkeeping" do
  menu if: proc{ authorized?(:read, "Bookkeeping::DataLoad") }, parent: I18n.t("active_admin.bookkeeping")

  content do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Bookkeeping::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
