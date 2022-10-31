ActiveAdmin.register Reshare::Transaction do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

  permit_params :borrower,
  :lender,
  :request_id,
  :borrower_id,
  :lender_id,
  :date_created,
  :borrower_last_updated,
  :lender_last_updated,
  :borrower_status,
  :lender_status,
  :title,
  :publication_date,
  :place_of_publication,
  :publisher,
  :call_number,
  :oclc_number,
  :barcode,
  :pick_location,
  :shelving_location,
  :pickup_location
end
