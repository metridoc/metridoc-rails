ActiveAdmin.register Illiad::LenderInfo,
as: "LenderInfo",
namespace: :illiad do
  menu false
  permit_params :institution_id, :address, :billing_category, :lender_code, :library_name
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :address, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :billing_category, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :lender_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :library_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
