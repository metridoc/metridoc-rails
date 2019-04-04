ActiveAdmin.register Illiad::Tracking do
  menu false
  permit_params :institution_id, :order_date, :process_type, :receive_date, :request_date, :request_type, :ship_date, :transaction_number, :turnaround_req_rec, :turnaround_req_shp, :turnaround_shp_rec, :turnarounds_processed
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :institution_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :order_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :process_type, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :receive_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :request_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :request_type, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :ship_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :turnaround_req_rec, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :turnaround_req_shp, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :turnaround_shp_rec, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :turnarounds_processed, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
