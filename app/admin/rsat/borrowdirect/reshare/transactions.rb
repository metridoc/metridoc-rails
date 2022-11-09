ActiveAdmin.register Rsat::Borrowdirect::Reshare::Transaction,
as: "Borrowdirect::Reshare::Transaction",
namespace: :rsat do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('RSAT', :rsat_root),
      link_to('BorrowDirect', :rsat_borrowdirect),
      link_to('ReShare', :rsat_borrowdirect_reshare)
    ]
  end
  
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
