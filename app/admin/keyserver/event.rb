ActiveAdmin.register Keyserver::Event,
namespace: :keyserver do
  menu false

  breadcrumb do
    [
      link_to('Keyserver', :keyserver_root)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  Keyserver::Event.superadmin_columns.each do |c|
    remove_filter c.to_sym
  end

  controller do
    def scoped_collection
      Keyserver::Event
        .select('keyserver_events.*, keyserver_sessions.location AS location')
        .joins(
          'LEFT JOIN keyserver_sessions
             ON  keyserver_sessions.computer_name = keyserver_events.computer_name
             AND keyserver_sessions.user_name     = keyserver_events.user_name
             AND keyserver_events.occurred_at    >= keyserver_sessions.logon
             AND (keyserver_sessions.logoff IS NULL
                  OR keyserver_events.occurred_at <= keyserver_sessions.logoff)'
        )
    end
  end

  index title: "Events" do
    column :computer_name
    column :occurred_at
    column :application
    column :version
    column :event_type
    column :product
    column :user_name if current_admin_user.super_admin?
    column :address
    column :location, sortable: 'keyserver_sessions.location'
  end
end
