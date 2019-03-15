ActiveAdmin.register Borrowdirect::Bibliography do
  menu false
  permit_params :request_number, :patron_id, :patron_type, :author, :title, :publisher, :publication_place, :publication_year, :edition, :lccn, :isbn, :isbn_2, :request_date, :process_date, :pickup_location, :borrower, :lender, :supplier_code, :call_number, :load_time, :oclc, :oclc_text, :bibliography_id, :version, :publication_date, :local_item_found
  actions :all, :except => [:new, :edit, :update, :destroy]
end
