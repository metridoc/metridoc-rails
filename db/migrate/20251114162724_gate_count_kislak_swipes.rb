class GateCountKislakSwipes < ActiveRecord::Migration[7.1]
  def change
    create_table :gate_count_kislak_swipes do |t|
      t.integer "fiscal_year"
      t.integer "year"
      t.integer "month"
      t.string "door_name"
      t.string "name"
      t.integer "total_swipes"

      t.index ["year", "month", "door_name", "name"], unique: true, name: "gate_count_kislak_swipe_uid"
    end
  end
end
