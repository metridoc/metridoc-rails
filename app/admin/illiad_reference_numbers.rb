ActiveAdmin.register Illiad::ReferenceNumber do
  menu false
  permit_params :institution_id, :oclc, :ref_number, :ref_type, :transaction_number
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :institution_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :oclc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :ref_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :ref_type, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :transaction_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
