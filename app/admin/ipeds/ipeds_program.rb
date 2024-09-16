ActiveAdmin.register Ipeds::Program, namespace: :ipeds do
  menu false

  # Define actions available
  actions :all, :except => [:new, :edit, :update, :destroy]

  # Define the filters to keep
  filter :year
  filter :unitid
  filter :cipcode

end
