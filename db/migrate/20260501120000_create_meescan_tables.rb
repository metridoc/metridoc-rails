class CreateMeescanTables < ActiveRecord::Migration[7.1]
  def change
    create_table :meescan_sessions do |t|
      t.integer  :year
      t.string   :month
      t.string   :fiscal_year
      t.string   :name
      t.integer  :item_count
      t.string   :item_return
      t.string   :language_code
      t.string   :device_model
      t.string   :device_os
      t.string   :device_os_version
      t.string   :app_version
      t.string   :kiosk_id
      t.float    :receipt_sent

      t.timestamps

      t.index [:created_at, :name, :item_count, :kiosk_id],
        unique: true,
        name: 'meescan_sessions_unique'
    end
  end
end
