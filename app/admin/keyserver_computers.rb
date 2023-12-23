ActiveAdmin.register Keyserver::Computer do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]
  permit_params :computer_id, :computer_name, :computer_platform, :computer_protocol, :computer_domain, :computer_division_id

  filter :computer_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :computer_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :computer_platform, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :computer_protocol, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :computer_domain, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :computer_division_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
