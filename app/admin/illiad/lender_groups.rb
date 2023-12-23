ActiveAdmin.register Illiad::LenderGroup,
as: "LenderGroup",
namespace: :illiad do
  menu false
  permit_params :institution_id, :demographic, :group_no, :lender_code
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :demographic, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :group_no, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :lender_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
