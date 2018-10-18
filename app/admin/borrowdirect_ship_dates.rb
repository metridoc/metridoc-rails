ActiveAdmin.register Borrowdirect::ShipDate do
  menu false
  permit_params :request_number, :ship_date, :exception_code, :process_date, :ship_date_id, :load_time, :version
end