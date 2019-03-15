ActiveAdmin.register Illiad::Group do
  menu false
  permit_params :institution_id, :group_name, :group_no
  actions :all, :except => [:new, :edit, :update, :destroy]
end
