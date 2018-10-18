ActiveAdmin.register Keyserver::Program do
  menu false
  permit_params :program_id, :program_server_id, :program_variant, :program_char_stamp, :program_name, :program_variant_name, :program_variant_version, :program_ai_version, :program_version_mask, :program_version, :program_platform, :program_publisher, :program_path, :program_file_name, :program_keyed, :program_status, :program_acknowledged, :program_audit, :program_folder_id, :program_launch_seen, :program_disc_method, :program_discovered, :program_create_date, :program_user_name, :program_computer_id, :program_notes, :program_flags
end