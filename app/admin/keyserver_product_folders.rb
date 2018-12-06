ActiveAdmin.register Keyserver::ProductFolder do
  menu false
  permit_params :prodfolder_id, :prodfolder_server_id, :prodfolder_name, :prodfolder_color, :prodfolder_notes, :prodfolder_flags
  actions :all, :except => [:edit, :update, :destroy]
end