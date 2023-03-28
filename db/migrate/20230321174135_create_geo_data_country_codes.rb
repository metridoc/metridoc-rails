class CreateGeoDataCountryCodes < ActiveRecord::Migration[5.2]
  def change
    # Create a new table GeoData::CountryCode
    create_table :geo_data_country_codes do |t|
      t.column :iso3166_1_alpha_3, :string
      t.column :iso3166_1_numeric, :string
      t.column :iso3166_alpha_2, :string
      t.column :cldr_display_name, :string
      t.column :unterm_english_short, :string
      t.column :unterm_english_official, :string
      t.column :region_name, :string
      t.column :sub_region_name, :string
      t.column :capital, :string
      t.column :marc, :string
      t.column :fips, :string
    end

    # Index the Datetime in EZProxy results
    add_index :upenn_ezproxy_ezpaarse_jobs, :datetime
  end
end
