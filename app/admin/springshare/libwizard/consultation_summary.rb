ActiveAdmin.register_page "Libwizard Consultation Summary",
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
  content title: "Cross Library Statistical Summary" do
    render partial: 'springshare/libwizard/consultation/summary'
  end  
end
