ActiveAdmin.register Ezborrow::PatronType do
  menu false
  permit_params :patron_type, :patron_type_desc, :ezb_patron_type_id
end