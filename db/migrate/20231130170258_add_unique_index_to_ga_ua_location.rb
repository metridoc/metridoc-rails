class AddUniqueIndexToGaUaLocation < ActiveRecord::Migration[6.1]
  def change
    remove_index :ga_ua_locations, name: :ga_ua_location_id, if_exists: true
    add_index(
      :ga_ua_locations,
      [
        "property", "fiscal_year", "date",
        "country_iso_code", "region_iso_code",
        "region", "metro", "city"
      ],
      unique: true,
      name: "ga_ua_location_id"
    )
  end
end
