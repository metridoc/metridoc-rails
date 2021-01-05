class CreateGoogleAnalyticsTables < ActiveRecord::Migration[5.2]
  def change
    create_table :google_analytics_events do |t|
      t.string :category
      t.string :action
      t.string :label
      t.integer :total
      t.timestamps
    end

    create_table :google_analytics_referrals do |t|
      t.string :source
      t.integer :users
      t.integer :new_users
      t.integer :sessions
      t.timestamps
    end
  end
end
