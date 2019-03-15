ActiveAdmin.register Borrowdirect::PatronType do
  menu false
  permit_params :patron_type, :patron_type_desc, :bd_patron_type_id
  actions :all, :except => [:new, :edit, :update, :destroy]
end
