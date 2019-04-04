ActiveAdmin.register Illiad::HistoryRecord do
  menu false
  permit_params :institution_id, :transaction_number, :record_datetime, :entry
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :institution_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :record_datetime, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :entry, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
