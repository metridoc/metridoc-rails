class ChangeCardNumColumn < ActiveRecord::Migration[5.2]
  def up
    change_column :gate_count_card_swipes, :card_num, :string
  end
  def down
    change_column :gate_count_card_swipes, :card_num, :integer
  end
end
