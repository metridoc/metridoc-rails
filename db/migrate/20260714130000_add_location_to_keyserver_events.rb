class AddLocationToKeyserverEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :keyserver_events, :location, :string
    add_index :keyserver_events, :location
  end
end
