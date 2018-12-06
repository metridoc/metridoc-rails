ActiveAdmin.register Keyserver::Server do
  menu false
  permit_params :server_id, :server_type, :server_name, :server_computer, :server_serial_number, :server_version, :server_start_time, :server_gmt_offset, :server_time_zone, :server_seats, :server_full_clients, :server_floating_sessions, :server_floating_ratio, :server_licenses_in_use, :server_licenses_in_queue
  actions :all, :except => [:edit, :update, :destroy]
end