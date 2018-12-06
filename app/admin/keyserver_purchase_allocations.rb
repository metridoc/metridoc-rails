ActiveAdmin.register Keyserver::PurchaseAllocation do
  menu false
  permit_params :allocation_id, :allocation_server_id, :allocation_purchase_id, :allocation_upgrade_id, :allocation_quantity, :allocation_flags
  actions :all, :except => [:edit, :update, :destroy]
end