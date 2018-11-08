ActiveAdmin.register Illiad::ReferenceNumber do
  menu false
  permit_params :institution_id, :oclc, :ref_number, :ref_type, :transaction_number
  actions :all, :except => [:edit, :update, :destroy]
end