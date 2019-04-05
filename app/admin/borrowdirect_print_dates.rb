ActiveAdmin.register Borrowdirect::PrintDate do
  menu false
  permit_params :request_number, :print_date, :note, :process_date, :print_date_id, :load_time, :library_id, :version
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :request_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :print_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :note, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :process_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :print_date_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :load_time, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :library_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :version, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
