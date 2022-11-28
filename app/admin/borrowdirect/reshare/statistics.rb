ActiveAdmin.register_page "Reshare Statistics",
namespace: :borrowdirect do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('ReShare', :borrowdirect_reshare)
    ]
  end

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "BorrowDirect Statistics" do
    # This is a sub div to the main_content div?? May not need
    div id: "borrowdirect_statistics" do
      # Direct path to dashboard template
      render partial: 'borrowdirect/reshare/statistics'
    end
  end

end
