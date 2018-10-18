ActiveAdmin.register Keyserver::UserFolder do
  menu false
  permit_params :usrfolder_id, :usrfolder_server_id, :usrfolder_name, :usrfolder_color, :usrfolder_notes, :usrfolder_flags
end