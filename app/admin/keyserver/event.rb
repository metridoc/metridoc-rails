ActiveAdmin.register Keyserver::Event,
namespace: :keyserver do
  menu false

  breadcrumb do
    [
      link_to('Keyserver', :keyserver_root)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Don't expose super-admin-only columns (user_name) through the filter sidebar.
  preserve_default_filters!
  Keyserver::Event.superadmin_columns.each do |c|
    remove_filter c.to_sym
  end

  controller do
    def scoped_collection
      Keyserver::Event
        .joins(
          "INNER JOIN keyserver_computers
             ON  keyserver_computers.computer_name = keyserver_events.computer_name
             AND keyserver_computers.section        = 'Public Computing'"
        )
    end
  end

  index title: "Events" do
    column :computer_name if current_admin_user.super_admin?
    column :occurred_at
    column :application
    column :version
    column :event_type
    column :product
    column :user_name if current_admin_user.super_admin?
    column :address
    column :location
  end
end
