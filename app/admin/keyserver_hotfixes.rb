ActiveAdmin.register Keyserver::Hotfix do
  menu false
  permit_params :hotfix_id, :hotfix_server_id, :hotfix_stamp, :hotfix_name, :hotfix_version, :hotfix_platform, :hotfix_publisher, :hotfix_create_date, :hotfix_user_name, :hotfix_computer_id, :hotfix_notes, :hotfix_flags
end