ActiveAdmin.register Keyserver::User do
  menu false
  permit_params :user_id, :user_server_id, :user_last_login, :user_computer_id, :user_folder_id, :user_external_id, :user_notes, :user_flags
  actions :all, :except => [:edit, :update, :destroy]
end
