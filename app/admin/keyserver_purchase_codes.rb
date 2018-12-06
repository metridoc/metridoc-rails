ActiveAdmin.register Keyserver::PurchaseCode do
  menu false
  permit_params :code_id, :code_server_id, :code_purchase_id, :code_value
  actions :all, :except => [:edit, :update, :destroy]
end
