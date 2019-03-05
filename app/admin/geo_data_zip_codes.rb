ActiveAdmin.register GeoData::ZipCode do
  menu false
  permit_params :zip_code, :latitude, :longitude
  actions :all, :except => [:edit, :update, :destroy]

  controller do
    before_action { @page_title = I18n.t("active_admin.geo_data.zip_codes") }
  end

end