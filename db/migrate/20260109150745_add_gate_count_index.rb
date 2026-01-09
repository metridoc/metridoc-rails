class AddGateCountIndex < ActiveRecord::Migration[7.1]
  def change
    # Add a unique index to gate count card swipes.
    add_index :gate_count_card_swipes, [
      :swipe_date, :door_name, :card_num
      ], unique: true, name: 'gate_count_card_swipes_uid'

    # Update the leganto view
    replace_view :cr_leganto_usage_views, version: 2, revert_to_version: 1
  end
end
