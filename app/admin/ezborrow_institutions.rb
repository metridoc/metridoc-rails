ActiveAdmin.register Ezborrow::Institution do
  menu false
  permit_params :catalog_code, :institution, :library_id, :ezb_institution_id, :version
  actions :all, :except => [:edit, :update, :destroy]
end
