ActiveAdmin.register GeoData::ZipCode do
  menu false
  permit_params :zip_code, :latitude, :longitude
  actions :all, :except => [:new, :edit, :update, :destroy]

  controller do
    before_action { @page_title = I18n.t("active_admin.geo_data.zip_codes") }
  end

  preserve_default_filters!

  filter :zip_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :latitude, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :longitude, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end