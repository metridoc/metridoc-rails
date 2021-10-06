ActiveAdmin.register_page "Consultation Summary" do

  breadcrumb do
    # Custom breadcrumb links
    [link_to('Admin', admin_root_path), link_to('Consultation', admin_consultation_path)]
  end

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "Cross Library Statistical Summary" do
    # This is a sub div to the main_content div?? May not need
    div id: "consultation_summary" do
      # Direct path to dashboard template
      render partial: 'admin/consultation/summary'
    end
  end
end
