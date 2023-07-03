ActiveAdmin.register_page "Statistical Summary" do

  #breadcrumb do
  #  [link_to('Admin',admin_root_path), link_to('Gate Counts',admin_gatecount_path)]
  #end

  #Don't add to the top menu
  menu false

  #Title for the page
  content title: "Statistical Summary of Gate Counts" do
    render partial: 'admin/gatecount/summary'
  end

  #Restrict the page view to the correct users:
  controller do
    private
    def authorize_access!
      authorize! :read, "Gate counts"
    end
  end

end
