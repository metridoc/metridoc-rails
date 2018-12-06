ActiveAdmin.register Keyserver::PurchaseDocument do
  menu false
  permit_params :document_id, :document_server_id, :document_purchase_id, :document_name, :document_url, :document_date_added
  actions :all, :except => [:edit, :update, :destroy]
end