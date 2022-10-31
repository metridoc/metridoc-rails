class DemographicAdditions < ActiveRecord::Migration[5.2]
  def change
    # Turn upenn_alma_demographics.status from a bool to a string field
    reversible do |dir|
      change_table :upenn_alma_demographics do |t|
        dir.up   { t.change :status, :string }
        dir.down { t.change :status, :boolean }
      end
    end
    # Add statistical_category_1 through statistical_category_5 and user_group and school
    # to gate_count_card_swipes and upenn_ezproxy_ezpaarse_jobs

    change_table :upenn_ezproxy_ezpaarse_jobs do |t|
      t.column :statistical_category_1, :string
      t.column :statistical_category_2, :string
      t.column :statistical_category_3, :string
      t.column :statistical_category_4, :string
      t.column :statistical_category_5, :string

      t.column :user_group, :text
      t.column :school, :string
    end

    change_table :gate_count_card_swipes do |t|
      t.column :statistical_category_1, :string
      t.column :statistical_category_2, :string
      t.column :statistical_category_3, :string
      t.column :statistical_category_4, :string
      t.column :statistical_category_5, :string

      t.column :user_group, :text
      t.column :school, :string
    end

  end
end
