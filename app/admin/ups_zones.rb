ActiveAdmin.register UpsZone do
  menu false
  permit_params :from_prefix, :to_prefix, :zone
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :from_prefix, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :to_prefix, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :zone, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end