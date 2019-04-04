ActiveAdmin.register Ezborrow::MinShipDate do
  menu false
  permit_params :request_number, :min_ship_date
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :request_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :min_ship_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
