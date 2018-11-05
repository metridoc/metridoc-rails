ActiveAdmin.register Keyserver::PurchaseOrder do
  menu false
  permit_params :order_id, :order_server_id, :order_date, :order_folder_id, :order_recipient, :order_reseller, :order_reseller_po, :order_notes, :order_flags
end