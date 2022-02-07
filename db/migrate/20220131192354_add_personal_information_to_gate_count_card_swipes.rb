class AddPersonalInformationToGateCountCardSwipes < ActiveRecord::Migration[5.2]
  def change
    add_column :gate_count_card_swipes, :card_num, :integer
    add_column :gate_count_card_swipes, :first_name, :string
    add_column :gate_count_card_swipes, :last_name, :string
  end
end
