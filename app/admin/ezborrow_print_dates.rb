ActiveAdmin.register Ezborrow::PrintDate do
  menu false
  permit_params :print_date_id, :request_number, :print_date, :note, :process_date, :load_time, :library_id, :version
end