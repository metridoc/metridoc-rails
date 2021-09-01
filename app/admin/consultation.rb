ActiveAdmin.register_page "Consultation" do
  menu if: proc{ authorized?(:read, "Consultation") },
    label: I18n.t("active_admin.consultation.consultation_menu"),
    parent: I18n.t("active_admin.resource_sharing")

    # Action need to get the redirect with parameters
    page_action :statistics, method: :post do
      redirect_url = "/admin/consultation_statistics?" +
        "staff_pennkey=#{params['pennkey']}"

      # Optionally add a start and end date to the url.
      unless params['start_date'].blank?
        redirect_url = redirect_url +
          "&start_date=#{params['start_date']}"
      end
      unless params['end_date'].blank?
        redirect_url = redirect_url +
          "&end_date=#{params['end_date']}"
      end

      redirect_to redirect_url
    end

  content do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select{|r| /^Consultation::/.match(r.resource_name.name) }
    resources = resources.sort{|a,b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: {resources: resources}
  end
end
