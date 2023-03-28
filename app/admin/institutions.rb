ActiveAdmin.register Institution do
  menu false
  permit_params :name, :code, :zip_code
  actions :all, :except => [:new, :edit, :update, :destroy]

  index do
    column :name
    column :code
    column :zip_code
  end

  preserve_default_filters!

  filter :name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :zip_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
