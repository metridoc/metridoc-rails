ActiveAdmin.register_page "Reshare Monthly Statistics",
namespace: :ezborrow do

  breadcrumb do
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('ReShare', :ezborrow_reshare)
    ]
  end

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "EZBorrow Monthly Statistics" do
    # Direct path to dashboard template
    render partial: 'ezborrow/reshare/monthly'
  end

end
