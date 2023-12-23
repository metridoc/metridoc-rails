ActiveAdmin.register Illiad::Tracking,
as: "Tracking",
namespace: :illiad do
  menu false

  permit_params :institution_id, :order_date, :process_type, :receive_date,
  :request_date, :request_type, :ship_date, :transaction_number,
  :turnaround_req_rec, :turnaround_req_shp, :turnaround_shp_rec,
  :turnarounds_processed

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :group_no
end
