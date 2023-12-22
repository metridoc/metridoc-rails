ActiveAdmin.register Illiad::Group,
as: "Group",
namespace: :illiad do
  menu false
  permit_params :institution_id, :group_name, :group_no
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :transaction_number

end
