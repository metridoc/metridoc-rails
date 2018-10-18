ActiveAdmin.register Ezborrow::Bibliography do
  menu false
  permit_params :bibliography_id, :request_number, :patron_id, :patron_type, :author, :title, :publisher, :publication_place, :publication_year, :edition, :lccn, :isbn, :isbn_2, :oclc, :request_date, :process_date, :pickup_location, :borrower, :lender, :supplier_code, :call_number, :load_time, :version, :local_item_found, :publication_date
end