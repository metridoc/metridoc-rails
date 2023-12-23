ActiveAdmin.register Illiad::Borrowing,
as: "Borrowing",
namespace: :illiad do
  menu false

  permit_params :institution_id, :request_type, :transaction_date,
  :transaction_number, :transaction_status

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :group_no
end
