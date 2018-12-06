ActiveAdmin.register Keyserver::Location do
  menu false
  permit_params :location_id, :location_server_id, :location_protocol, :location_name, :location_range_begin, :location_range_end, :location_allowed, :location_notes, :location_flags
  actions :all, :except => [:edit, :update, :destroy]
end
