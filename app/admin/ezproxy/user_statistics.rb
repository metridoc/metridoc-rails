ActiveAdmin.register_page "User Statistics",
namespace: :ezproxy do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EZProxy', :ezproxy_root),
      link_to('Statistics', :ezproxy_statistics)
    ]
  end

  # Do not add to top menu
  menu false

  # General title for the page
  content title: "User Statistics" do
    # Direct path to dashboard template
    render partial: 'ezproxy/statistics/user_statistics'
  end

end
