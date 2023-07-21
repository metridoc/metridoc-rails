ActiveAdmin.register_page "Undergraduate Statistics" do

  breadcrumb do
    [link_to('Admin',admin_root_path), link_to('Gate Counts',admin_gatecount_path),link_to('Population',admin_population_penetration_path)]
  end

  #Don't add to the top menu
  menu false

  #Title for the page
  content title: "Undergraduate Statistics" do
    render partial: 'admin/gatecount/undergrad_stats'
  end

  #Restrict the page view to the correct users:
  controller do
    private
    def authorize_access!
      authorize! :read, "GateCount"
    end
  end

end
