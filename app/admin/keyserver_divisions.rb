ActiveAdmin.register Keyserver::Division do
  menu false
  permit_params :division_id, :division_server_id, :division_name, :division_section_id, :division_notes, :division_flags
  actions :all, :except => [:new, :edit, :update, :destroy]

  filter :division_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :division_server_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :division_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :division_section_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :division_notes, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :division_flags, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
