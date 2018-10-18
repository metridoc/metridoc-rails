ActiveAdmin.register Keyserver::Audit do
  menu false
  permit_params :audit_id, :audit_server_id, :audit_computer_id, :audit_program_id, :audit_size, :audit_count, :audit_first_seen, :audit_last_seen, :audit_last_used, :audit_serial_number, :audit_path
end