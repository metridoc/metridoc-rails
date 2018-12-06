ActiveAdmin.register Ezborrow::CallNumber do
  menu false
  permit_params :call_number_id, :request_number, :holdings_seq, :supplier_code, :call_number, :process_date, :load_time, :version
  actions :all, :except => [:edit, :update, :destroy]
end
