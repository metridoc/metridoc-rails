class CreateHostLmsShelvingLocation < ActiveRecord::Migration[5.2]
  def change
    create_table :bd_reshare_host_lms_shelving_locations do |t|
      t.string :hlsl_id
      t.string :origin
      t.datetime :hlsl_date_created
      t.datetime :hlsl_last_updated
      t.integer :hlsl_version
      t.string :hlsl_code
      t.string :hlsl_name
      t.integer :hlsl_supply_preference
      t.boolean :hlsl_hidden

      t.index ["hlsl_id"], name: "bd_reshare_shelving_location_index", unique: true
    end

    create_table :reshare_host_lms_shelving_locations do |t|
      t.string :hlsl_id
      t.string :origin
      t.datetime :hlsl_date_created
      t.datetime :hlsl_last_updated
      t.integer :hlsl_version
      t.string :hlsl_code
      t.string :hlsl_name
      t.integer :hlsl_supply_preference
      t.boolean :hlsl_hidden

      t.index ["hlsl_id"], name: "reshare_shelving_location_index", unique: true
    end
  end
end
