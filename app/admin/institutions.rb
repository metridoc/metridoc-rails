ActiveAdmin.register Institution do
  menu false
  permit_params :name, :code, :zip_code
  actions :all, :except => [:edit, :update, :destroy]
  
  index do
    column :name
    column :code
    column :zip_code
    column :ups_zone
  end
end