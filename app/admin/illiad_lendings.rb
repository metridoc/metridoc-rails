ActiveAdmin.register Illiad::Lending do
  menu false
  permit_params :institution_id, :request_type, :status, :transaction_date, :transaction_number
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :institution_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :request_type, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :status, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
