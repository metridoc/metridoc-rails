ActiveAdmin.register Keyserver::Computer,
namespace: :keyserver do
  menu false
  actions :all, :except => [:new, :create, :edit, :update, :destroy]

  breadcrumb do
    [
      link_to('Keyserver', :keyserver_root)
    ]
  end
  
end