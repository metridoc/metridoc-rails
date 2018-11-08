ActiveAdmin.register Keyserver::PolicyFolder do
  menu false
  permit_params :polfolder_id, :polfolder_server_id, :polfolder_name, :polfolder_color, :polfolder_notes, :polfolder_flags
  actions :all, :except => [:edit, :update, :destroy]
end