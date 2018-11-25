ActiveAdmin.register Institution do
  menu false
  permit_params :name, :code, :zip_code
  actions :all, :except => [:edit, :update, :destroy]
end