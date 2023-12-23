ActiveAdmin.register Institution do
  menu false
  permit_params :name, :code, :zip_code
  actions :all, :except => [:new, :edit, :update, :destroy]

  index do
    column :name
    column :code
    column :zip_code
  end

end
