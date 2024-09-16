ActiveAdmin.register Borrowdirect::Relais::Bibliography,
as: "Relais::Bibliography",
namespace: :borrowdirect do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('Relais', :borrowdirect_relais)
    ]
  end

  permit_params :request_number, :patron_id, :patron_type, :author, :title,
  :publisher, :publication_place, :publication_year, :edition, :lccn,
  :isbn, :isbn_2, :request_date, :process_date, :pickup_location, :borrower,
  :lender, :supplier_code, :call_number, :load_time, :oclc, :oclc_text,
  :bibliography_id, :version, :publication_date, :local_item_found

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :library_id

  filter :borrower, filters: [:cont, :not_cont, :start, :end, :eq], :input_html => { :maxlength => 8 }
  filter :lender, filters: [:cont, :not_cont, :start, :end, :eq], :input_html => { :maxlength => 8 }

  # Set the title on the index page
  index title: "Bibliography"
end
