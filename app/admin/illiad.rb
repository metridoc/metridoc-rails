ActiveAdmin.register_page "Illiad" do
  menu if: proc{ authorized?(:read, "Illiad") }, label: I18n.t("active_admin.illiad.illiad_menu"), parent: I18n.t("active_admin.resource_sharing")

  # Action need to get the redirect with parameters
  page_action :statistics, method: :post do
    redirect_to "/admin/illiad_statistics?fiscal_year=#{params['fiscal_year']}&library_id=#{params['library_id']}"
  end

  content title: I18n.t("active_admin.illiad.illiad_menu") do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Illiad::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
