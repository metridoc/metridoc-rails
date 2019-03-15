ActiveAdmin.register Illiad::LendingTracking do
  menu false
  permit_params :institution_id, :arrival_date, :completion_date, :completion_status, :request_type, :transaction_number, :turnaround
  actions :all, :except => [:new, :edit, :update, :destroy]
end
