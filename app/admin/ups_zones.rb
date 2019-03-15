ActiveAdmin.register UpsZone do
  menu false
  permit_params :from_prefix, :to_prefix, :zone
  actions :all, :except => [:new, :edit, :update, :destroy]
end