ActiveAdmin.register Ezborrow::MinShipDate do
  menu false
  permit_params :request_number, :min_ship_date
end