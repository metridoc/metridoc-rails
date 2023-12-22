ActiveAdmin.register Illiad::DocDelTracking,
as: "DocDelTracking",
namespace: :illiad do
  menu false

  permit_params :institution_id, :arrival_date, :completion_date,
  :completion_status, :request_type, :transaction_number, :turnaround

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :group_no

end
