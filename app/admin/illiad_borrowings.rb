ActiveAdmin.register Illiad::Borrowing do
  menu false
  permit_params :institution_id, :request_type, :transaction_date, :transaction_number, :transaction_status
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :institution_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :request_type, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_status, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
