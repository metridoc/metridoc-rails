ActiveAdmin.register_page "Statistics",
namespace: :ezproxy do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EZProxy', :ezproxy_root)
    ]
  end

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "Statistics" do
    # Direct path to dashboard template
    render partial: 'statistics'
  end

end
