class CreateGateCountIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :gate_count_card_swipes, :door_name
    add_index :gate_count_card_swipes, :affiliation_desc
    add_index :gate_count_card_swipes, :center_desc
    add_index :gate_count_card_swipes, :dept_desc
    add_index :gate_count_card_swipes, :usc_desc
  end
end
