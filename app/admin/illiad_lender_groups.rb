ActiveAdmin.register Illiad::LenderGroup do
  menu false
  permit_params :institution_id, :demographic, :group_no, :lender_code
  actions :all, :except => [:new, :edit, :update, :destroy]
end
