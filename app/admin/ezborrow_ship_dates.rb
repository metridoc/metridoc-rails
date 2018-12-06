ActiveAdmin.register Ezborrow::ShipDate do
  menu false
  permit_params :ship_date_id, :request_number, :ship_date, :exception_code, :process_date, :load_time, :version
  actions :all, :except => [:edit, :update, :destroy]
end
