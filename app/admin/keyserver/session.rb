ActiveAdmin.register Keyserver::Session,
namespace: :keyserver do
  menu false

  breadcrumb do
    [
      link_to('Keyserver', :keyserver_root)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  Keyserver::Session.superadmin_columns.each do |c|
    remove_filter c.to_sym
  end

  index title: "Sessions" do
    column :computer_name if current_admin_user.super_admin?
    column :user_name if current_admin_user.super_admin?
    column :logon
    column :logoff
    column :duration
    column :address
    column :location
  end
end
