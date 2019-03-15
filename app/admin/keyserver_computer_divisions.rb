ActiveAdmin.register Keyserver::ComputerDivision do
  menu false
  permit_params :division_id, :division_server_id, :division_name, :division_color, :division_notes, :division_flags
  actions :all, :except => [:new, :edit, :update, :destroy]
end
