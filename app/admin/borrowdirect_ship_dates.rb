ActiveAdmin.register Borrowdirect::ShipDate do
  menu false
  permit_params :request_number, :ship_date, :exception_code, :process_date, :ship_date_id, :load_time, :version
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :request_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :ship_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :exception_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :process_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :ship_date_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :load_time, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :version, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
