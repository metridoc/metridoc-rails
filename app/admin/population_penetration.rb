ActiveAdmin.register_page "Population & Penetration" do

  breadcrumb do
    [link_to('Admin',admin_root_path), link_to('Gate Counts',admin_gatecount_path)]
  end

  #Don't add to the top menu
  menu false

  #Action needed to define variables for frequency plots
  page_action :population, method: :post do
    @input_school = params[:school]
    @input_library = params[:libary]
  end

  def index
  end
    
  #Title for the page
  content title: "Populations & Penetration" do
    render partial: 'admin/gatecount/population'
  end

  #Restrict the page view to the correct users:
  controller do
    private
    def authorize_access!
      authorize! :read, "GateCount"
    end
  end

end
