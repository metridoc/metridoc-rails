ActiveAdmin.register Illiad::LenderInfo do
  menu false
  permit_params :institution_id, :address, :billing_category, :lender_code, :library_name
  actions :all, :except => [:new, :edit, :update, :destroy]
end
