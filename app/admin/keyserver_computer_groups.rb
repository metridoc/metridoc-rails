ActiveAdmin.register Keyserver::ComputerGroup do
  menu false
  permit_params :group_id, :group_server_id, :group_num_members, :group_max_members, :group_notes, :group_flags
  actions :all, :except => [:new, :edit, :update, :destroy]
end
