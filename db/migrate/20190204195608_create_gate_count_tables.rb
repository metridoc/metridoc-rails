class CreateGateCountTables < ActiveRecord::Migration[5.1]
  def change
    create_table :gate_count_card_swipes do |t|
      t.date :swipe_date
      t.string :swipe_time
      t.string :door_name
      t.string :affiliation_desc
      t.string :center_desc
      t.string :dept_desc
      t.string :usc_desc
    end
  end
end
