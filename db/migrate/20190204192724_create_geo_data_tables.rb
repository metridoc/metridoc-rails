class CreateGeoDataTables < ActiveRecord::Migration[5.1]
  def change
    create_table :geo_data_zip_codes do |t|
      t.string :zip_code
      t.string :latitude
      t.string :longitude
    end
  end
end
