ActiveAdmin.register Illiad::Group do
  menu false
  permit_params :institution_id, :group_name, :group_no
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :group_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :group_no, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
