ActiveAdmin.register Keyserver::Computer do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]
  permit_params :computer_id,
  :computer_name,
  :computer_platform,
  :computer_protocol,
  :computer_domain,
  :computer_division_id

end
