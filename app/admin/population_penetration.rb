ActiveAdmin.register_page "Population & Penetration" do

  breadcrumb do
    [link_to('Admin',admin_root_path), link_to('Populations & Penetration',admin_gatecount_path)]
  end

  #Don't add to the top menu
  menu false

  #Title for the page
  content title: "Gate Counts Overview" do
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
