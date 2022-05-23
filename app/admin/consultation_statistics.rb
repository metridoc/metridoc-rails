ActiveAdmin.register_page "Consultation Statistics" do

  breadcrumb do
    # Custom breadcrumb links
    [link_to('Admin', admin_root_path), link_to('Consultation and Instruction', admin_consultation_path)]
  end

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "Individual Librarian Statistics" do
    # This is a sub div to the main_content div?? May not need
    div id: "consultation_statistics" do
      # Direct path to dashboard template
      render partial: 'admin/consultation/statistics'
    end
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
