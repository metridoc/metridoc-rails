ActiveAdmin.register Keyserver::PurchaseFolder do
  menu false
  permit_params :purchfolder_id, :purchfolder_server_id, :purchfolder_name, :purchfolder_color, :purchfolder_notes, :purchfolder_flags
  actions :all, :except => [:edit, :update, :destroy]
end