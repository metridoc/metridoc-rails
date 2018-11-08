ActiveAdmin.register Keyserver::Product do
  menu false
  permit_params :product_id, :product_server_id, :product_name, :product_version, :product_platform, :product_release_date, :product_folder_id, :product_upgrade_id, :product_status, :product_tracked, :product_publisher, :product_category, :product_contact, :product_contact_address, :product_defined_by, :product_notes, :product_flags
  actions :all, :except => [:edit, :update, :destroy]
end