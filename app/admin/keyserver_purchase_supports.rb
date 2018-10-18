ActiveAdmin.register Keyserver::PurchaseSupport do
  menu false
  permit_params :support_id, :support_server_id, :support_purchase_id, :support_product_id
end