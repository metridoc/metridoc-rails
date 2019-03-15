ActiveAdmin.register Keyserver::ComputerGroupMember do
  menu false
  permit_params :member_id, :member_server_id, :member_computer_id, :member_group_id, :member_acknowledged, :member_last_used
  actions :all, :except => [:new, :edit, :update, :destroy]
end
