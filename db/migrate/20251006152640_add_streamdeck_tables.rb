class AddStreamdeckTables < ActiveRecord::Migration[7.1]
  def change
    create_table :sd_sp_entries do |t|
      t.string "computer_id"
      t.string "button"
      t.string "username"
      t.datetime "timestamp"
      t.datetime "downloaded_at"

      t.index ["computer_id", "timestamp"], unique: true, name: "sd_sp_entry_id"
    end
    create_table :sd_sp_queries do |t|
      t.integer "count" 
      t.integer "scanned_count"
      t.float "capacity_units"
      t.datetime "downloaded_at"

      t.index "downloaded_at", unique: true
    end
  end
end
