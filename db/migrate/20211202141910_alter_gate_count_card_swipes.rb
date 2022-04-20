class AlterGateCountCardSwipes < ActiveRecord::Migration[5.2]
  def up
    change_table :gate_count_card_swipes do |t|
      t.remove :swipe_time
    end
    change_column :gate_count_card_swipes, :swipe_date, :datetime
  end
  def down
    change_table :gate_count_card_swipes do |t|
      t.string :swipe_time
    end
    change_column :gate_count_card_swipes, :swipe_date, :date
  end
end
