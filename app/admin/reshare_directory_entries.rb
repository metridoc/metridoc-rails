ActiveAdmin.register Reshare::DirectoryEntry do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

  permit_params :origin,
  :de_id,
  :version,
  :de_slug,
  :de_name,
  :de_status_fk,
  :de_parent,
  :de_lms_location_code,
  :last_updated

  preserve_default_filters!
  filter :de_slug, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
