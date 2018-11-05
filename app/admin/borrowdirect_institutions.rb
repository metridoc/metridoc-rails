ActiveAdmin.register Borrowdirect::Institution do
  menu false
  permit_params :catalog_code, :institution, :library_id, :version, :bd_institution_id
end