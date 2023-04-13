ActiveAdmin.register Ezproxy::EzpaarsePlatform,
as: "Ezpaarse Platforms",
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
