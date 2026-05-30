class AddUniqueIndexesToKeyserverTables < ActiveRecord::Migration[7.0]
  def change
    add_index :keyserver_events,
              [:computer_name, :occurred_at, :application, :event_type, :user_name],
              unique: true,
              name: "index_keyserver_events_natural_key"

    add_index :keyserver_sessions,
              [:computer_name, :user_name, :logon],
              unique: true,
              name: "index_keyserver_sessions_natural_key"
  end
end
