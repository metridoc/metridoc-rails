ActiveAdmin.register Ezproxy::EzpaarseJob,
as: "Ezpaarse Jobs",
namespace: :ezproxy do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EZProxy', :ezproxy_root)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]
end
