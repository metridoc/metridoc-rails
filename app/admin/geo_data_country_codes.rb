ActiveAdmin.register GeoData::CountryCode do
  menu false
  permit_params :iso3166_1_alpha_3, # Three letter code
  :iso3166_1_numeric, # Numeric code
  :iso3166_alpha_2, # Two letter code
  :cldr_display_name, # Customary English Name
  :unterm_english_short, # Short English name from the UN Protocol and Liaison Service
  :unterm_english_official, # Formal English name from the UN Protocol and Liaison Service
  :region_name, # Continent
  :sub_region_name, # SubContinent
  :capital, # Country Capital
  :marc, # Machine Readable Code
  :fips # Federal Infomration Processing Standards

  actions :all, :except => [:new, :edit, :update, :destroy]

  controller do
    before_action { @page_title = I18n.t("active_admin.geo_data.country_codes") }
  end

end
