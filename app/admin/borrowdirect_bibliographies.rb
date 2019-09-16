ActiveAdmin.register Borrowdirect::Bibliography do
  menu false
  permit_params :request_number, :patron_id, :patron_type, :author, :title, :publisher, :publication_place, :publication_year, :edition, :lccn, :isbn, :isbn_2, :request_date, :process_date, :pickup_location, :borrower, :lender, :supplier_code, :call_number, :load_time, :oclc, :oclc_text, :bibliography_id, :version, :publication_date, :local_item_found
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  filter :request_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :patron_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :patron_type, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :author, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :title, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :publisher, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :publication_place, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :publication_year, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :edition, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :lccn, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :isbn, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :isbn_2, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :request_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :process_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :pickup_location, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :borrower, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :lender, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :supplier_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :call_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :load_time, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :oclc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :oclc_text, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :bibliography_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :version, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :publication_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :local_item_found, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
