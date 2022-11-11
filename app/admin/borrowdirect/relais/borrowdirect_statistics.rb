ActiveAdmin.register_page "Relais",
namespace: :borrowdirect do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('Relais', :borrowdirect_relais)
    ]
  end

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "BorrowDirect Statistics" do
    # This is a sub div to the main_content div?? May not need
    div id: "borrowdirect_statistics" do
      # Direct path to dashboard template
      render partial: 'statistics'
    end
  end

end
