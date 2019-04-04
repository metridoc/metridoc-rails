ActiveAdmin.register Ezborrow::PrintDate do
  menu false
  permit_params :print_date_id, :request_number, :print_date, :note, :process_date, :load_time, :library_id, :version
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :print_date_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :request_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :print_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :note, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :process_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :load_time, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :library_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :version, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
