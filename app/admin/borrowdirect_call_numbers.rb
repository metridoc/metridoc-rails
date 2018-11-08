ActiveAdmin.register Borrowdirect::CallNumber do
  menu false
  permit_params :request_number, :holdings_seq, :supplier_code, :call_number, :process_date, :load_time, :call_number_id, :version
  actions :all, :except => [:edit, :update, :destroy]
end