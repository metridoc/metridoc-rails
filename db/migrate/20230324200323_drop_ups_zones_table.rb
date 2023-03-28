class DropUpsZonesTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :ups_zones do |t|
      t.string "from_prefix", null: false
      t.string "to_prefix", null: false
      t.integer "zone", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
