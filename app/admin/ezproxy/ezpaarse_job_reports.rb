ActiveAdmin.register Ezproxy::EzpaarseJobReport,
as: "Ezpaarse Job Reports",
namespace: :ezproxy do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EZProxy', :ezproxy_root)
    ]
  end

end
