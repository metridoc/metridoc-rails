ActiveAdmin.register Keyserver::Program do
  menu false
  permit_params :program_id,
  :program_variant,
  :program_variant_name,
  :program_variant_version,
  :program_platform,
  :program_publisher,
  :program_status
  actions :all, :except => [:new, :edit, :update, :destroy]
end
