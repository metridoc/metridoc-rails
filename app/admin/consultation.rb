# frozen_string_literal: true

ActiveAdmin.register_page 'Consultation' do
  menu false

  # Action need to get the redirect with parameters
  page_action :statistics, method: :post do
    redirect_url = '/admin/consultation_statistics?' \
                   "staff_pennkey=#{params['pennkey']}"

    # Optionally add a start and end date to the url.
    redirect_url += "&start_date=#{params['start_date']}" unless params['start_date'].blank?
    redirect_url += "&end_date=#{params['end_date']}" unless params['end_date'].blank?

    redirect_to redirect_url
  end

  content title: "Consultation and Instruction" do
    resource_collection = ActiveAdmin.application.namespaces[:admin].resources
    resources = resource_collection.select { |resource| resource.respond_to? :resource_class }
    resources = resources.select { |r| /^Consultation::/.match(r.resource_name.name) }
    resources = resources.sort { |a, b| a.resource_name.human <=> b.resource_name.human }

    render partial: 'index', locals: { resources: resources }
  end

  # Redefine ActiveAdmin::PageController::authorize_access
  # This will restrict the page view to the correct users.
  controller do
    private
    def authorize_access!
      authorize! :read, "Consultation"
    end
  end
end
