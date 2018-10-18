ActiveAdmin.register Keyserver::ProgramFolder do
  menu false
  permit_params :folder_id, :folder_server_id, :folder_name, :folder_color, :folder_notes, :folder_flags
end