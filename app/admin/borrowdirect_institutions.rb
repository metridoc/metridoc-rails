ActiveAdmin.register Borrowdirect::Institution do
  menu false
  permit_params :library_id, :library_symbol, :institution_name, :prime_post_zipcode, :weighting_factor
  actions :all, :except => [:new, :edit, :update, :destroy]
end
