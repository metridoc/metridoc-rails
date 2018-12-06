class UpsZoneTable < ActiveRecord::Migration[5.1]
  def change

    create_table :ups_zones do |t|
      t.string     :from_prefix, null: false
      t.string     :to_prefix, null: false
      t.integer    :zone, null: false
      t.timestamps null: false
    end

  end
end
