ActiveAdmin.register Ezborrow::Relais::Bibliography,
as: "Relais::Bibliography",
namespace: :ezborrow do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('Relais', :ezborrow_relais)
    ]
  end

  permit_params :bibliography_id, :request_number, :patron_id, :patron_type,
  :author, :title, :publisher, :publication_place, :publication_year,
  :edition, :lccn, :isbn, :isbn_2, :oclc, :request_date, :process_date,
  :pickup_location, :borrower, :lender, :supplier_code, :call_number,
  :load_time, :version, :local_item_found, :publication_date

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :library_id

  filter :borrower, filters: [:cont, :not_cont, :start, :end, :eq], :input_html => { :maxlength => 8 }
  filter :lender, filters: [:cont, :not_cont, :start, :end, :eq], :input_html => { :maxlength => 8 }

  # Set the title on the index page
  index title: "Bibliography"
end
