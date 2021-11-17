ActiveAdmin.register Illiad::DocDelTracking do
  menu false
  permit_params :institution_id, :arrival_date, :completion_date, :completion_status, :request_type, :transaction_number, :turnaround
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :arrival_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :completion_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :completion_status, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :request_type, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :turnaround, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
