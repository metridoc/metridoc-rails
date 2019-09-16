class AddBookkeepingTable < ActiveRecord::Migration[5.1]
  def change
    create_table :data_loads_ranges do |t|
      t.string :table_name
      t.datetime :start
      t.datetime :end
    end
  end
end
