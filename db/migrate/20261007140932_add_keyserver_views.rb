class AddKeyserverViews < ActiveRecord::Migration[8.1]
  def change

    add_column :keyserver_sessions, :computers_per_division, :integer

    create_view :keyserver_concurrent_sessions, materialized: true    
    add_index :keyserver_concurrent_sessions, :id, unique: true

    create_view :keyserver_occupancies, materialized: true    
    add_index :keyserver_occupancies, [:computer_name, :date, :hour_of_day], unique: true

  end
end
