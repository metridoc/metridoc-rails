ActiveAdmin.register Illiad::HistoryRecord do
  menu false
  permit_params :institution_id, :transaction_number, :record_datetime, :entry
  actions :all, :except => [:new, :edit, :update, :destroy]
end
