ActiveAdmin.register Borrowdirect::PrintDate do
  menu false
  permit_params :request_number, :print_date, :note, :process_date, :print_date_id, :load_time, :library_id, :version
  actions :all, :except => [:edit, :update, :destroy]
end