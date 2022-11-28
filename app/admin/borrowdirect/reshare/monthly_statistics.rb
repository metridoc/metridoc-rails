ActiveAdmin.register_page "Reshare Monthly Statistics",
namespace: :borrowdirect do

  breadcrumb do
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('ReShare', :borrowdirect_reshare)
    ]
  end

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "BorrowDirect Monthly Statistics" do
    # Direct path to dashboard template
    render partial: 'borrowdirect/reshare/monthly'
  end

end
