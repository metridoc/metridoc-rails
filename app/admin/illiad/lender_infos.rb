ActiveAdmin.register Illiad::LenderInfo,
as: "LenderInfo",
namespace: :illiad do
  menu false
  permit_params :institution_id, :address, :billing_category, :lender_code,
  :library_name
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :group_no
  remove_filter :transaction_number
end
