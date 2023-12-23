ActiveAdmin.register Keyserver::Division do
  menu false
  permit_params :division_id,
  :division_server_id,
  :division_name,
  :division_section_id,
  :division_notes,
  :division_flags
  actions :all, :except => [:new, :edit, :update, :destroy]

end
