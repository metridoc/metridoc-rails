ActiveAdmin.register Reshare::DirectoryEntry do
  menu false
  permit_params :de_slug

  filter :de_slug, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
