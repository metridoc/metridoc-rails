ActiveAdmin.register_page "GateCount" do
  menu false

  #Action needed to define variables for frequency plots
  page_action :population, method: :post do
    @input_school = params[:school]
    @input_library = params[:library]
    @input_year = params[:year]
    redirect_url = "/admin/population_penetration?library=#{params['library']}&school=#{params['school']}"
    redirect_to redirect_url

  end
  
  content title: I18n.t("active_admin.gate_counts") do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^GateCount::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end

  # Redefine ActiveAdmin::PageController::authorize_access
  # This will restrict the page view to the correct users.
  controller do
    private
    def authorize_access!
      authorize! :read, "GateCount"
    end
  end

end
