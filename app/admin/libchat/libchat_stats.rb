ActiveAdmin.register_page "Libchat Statistics" do

  breadcrumb do
    [link_to('Admin',admin_root_path), link_to('Libchat',admin_gatecount_path)]
  end

  #Don't add to the top menu
  menu false

  #Title for the page
  content title: "Libchat Statistics" do
    render partial: 'admin/libchat/statistics'
  end

  #Restrict the page view to the correct users:
  controller do
    private
    def authorize_access!
      authorize! :read, "Libchat"
    end
  end

end
