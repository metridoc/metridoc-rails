class UpdateDemographics < ActiveRecord::Migration[5.2]
  def change

    change_table :upenn_ezproxy_ezpaarse_jobs do |t|
      t.column :penn_id, :text
    end

    change_table :gate_count_card_swipes do |t|
      t.column :pennkey, :text
    end

  end
end
