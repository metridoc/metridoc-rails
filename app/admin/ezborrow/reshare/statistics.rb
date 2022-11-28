ActiveAdmin.register_page "Reshare Statistics",
namespace: :ezborrow do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('ReShare', :ezborrow_reshare)
    ]
  end

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "EZBorrow Statistics" do
    # Direct path to dashboard template
    render partial: 'ezborrow/reshare/statistics'
  end

end
