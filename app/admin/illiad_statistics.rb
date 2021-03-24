ActiveAdmin.register_page "ILLiad Statistics" do

  breadcrumb do
    # Custom breadcrumb links
    [link_to('Admin', admin_root_path), link_to('ILLiad', admin_illiad_path)]
  end

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "ILLiad Statistics" do
    # This is a sub div to the main_content div?? May not need
    div id: "illiad_statistics" do
      # Direct path to dashboard template
      render partial: 'admin/illiad/statistics'
    end
  end
end
