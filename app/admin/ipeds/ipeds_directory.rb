ActiveAdmin.register Ipeds::Directory, namespace: :ipeds do
  menu false

  # Define actions available
  actions :all, except: [:edit, :destroy]

  # Define the filters to keep
  filter :unitid
  filter :instnm
  filter :stabbr
  filter :c18_basic
end
