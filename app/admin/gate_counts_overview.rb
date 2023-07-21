ActiveAdmin.register_page "Gate Counts Overview" do

  breadcrumb do
    [link_to('Admin',admin_root_path), link_to('Gate Counts',admin_gatecount_path)]
  end

  #Don't add to the top menu
  menu false

   #Action needed to define variables for frequency plots
  age_action :frequency, method: :get do
    @input_school = params[:school]

  end
  
  #Title for the page
  content title: "Gate Counts Overview" do
    render partial: 'admin/gatecount/overview'
  end

  #Restrict the page view to the correct users:
  controller do
    private
    def authorize_access!
      authorize! :read, "GateCount"
    end
  end

end
