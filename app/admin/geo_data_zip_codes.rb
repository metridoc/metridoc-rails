ActiveAdmin.register GeoData::ZipCode do
  menu false
  permit_params :zip_code, :latitude, :longitude
  actions :all, :except => [:edit, :update, :destroy]
end