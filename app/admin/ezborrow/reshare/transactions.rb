ActiveAdmin.register Ezborrow::Reshare::Transaction,
as: "Reshare::Transaction",
namespace: :ezborrow do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('ReShare', :ezborrow_reshare)
    ]
  end

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

# Set the title on the index page
index title: "Transaction"
end
