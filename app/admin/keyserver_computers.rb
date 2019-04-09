ActiveAdmin.register Keyserver::Computer do
  menu false
  permit_params :computer_id, :computer_name, :computer_platform, :computer_protocol, :computer_domain, :computer_description
end