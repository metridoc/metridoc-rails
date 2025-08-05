ActiveAdmin.register_page "Libwizard Consultation Statistics",
as: "Libwizard Consultation Statistics",
namespace: :springshare do
  menu false
  
  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('Springshare', :springshare_root),
      link_to('LibWizard', :springshare_libwizard)
    ]
  end

  # General title for the page
  content title: "Individual Librarian Statistics" do
    render partial: 'springshare/libwizard/consultation/statistics'
  end
end
