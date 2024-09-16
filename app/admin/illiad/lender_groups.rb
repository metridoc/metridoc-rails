ActiveAdmin.register Illiad::LenderGroup,
as: "LenderGroup",
namespace: :illiad do
  menu false
  permit_params :institution_id, :demographic, :group_no, :lender_code
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :transaction_number
end
