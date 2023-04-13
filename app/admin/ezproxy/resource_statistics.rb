ActiveAdmin.register_page "Resource Statistics",
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
  content title: "Resource Statistics" do
    # Direct path to dashboard template
    render partial: 'ezproxy/statistics/resource_statistics'
  end

end
