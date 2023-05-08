class CreateHostLmsLocation < ActiveRecord::Migration[5.2]
  def change
    create_table :bd_reshare_host_lms_locations do |t|
      t.string :hll_id
      t.string :origin
      t.datetime :hll_date_created
      t.datetime :hll_last_updated
      t.integer :hll_version
      t.string :hll_code
      t.string :hll_name
      t.integer :hll_supply_preference
      t.string :hll_corresponding_de
      t.boolean :hll_hidden

      t.index ["hll_id"], name: "bd_reshare_location_index", unique: true
    end

    create_table :reshare_host_lms_locations do |t|
      t.string :hll_id
      t.string :origin
      t.datetime :hll_date_created
      t.datetime :hll_last_updated
      t.integer :hll_version
      t.string :hll_code
      t.string :hll_name
      t.integer :hll_supply_preference
      t.string :hll_corresponding_de
      t.boolean :hll_hidden

      t.index ["hll_id"], name: "reshare_location_index", unique: true
    end
  end
end
