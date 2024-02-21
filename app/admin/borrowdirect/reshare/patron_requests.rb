ActiveAdmin.register Borrowdirect::Reshare::PatronRequest,
as: "Reshare::PatronRequest",
namespace: :borrowdirect  do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('ReShare', :borrowdirect_reshare)
    ]
  end

  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

  permit_params :last_updated,
  :pr_id,
  :pr_hrid,
  :pr_version,
  :pr_date_created,
  :pr_patron_type,
  :pr_resolved_req_inst_symbol_fk,
  :pr_resolved_pickup_location_fk,
  :pr_pickup_location_slug,
  :pr_resolved_sup_inst_symbol_fk,
  :pr_pick_location_fk,
  :pr_pick_shelving_location,
  :pr_local_call_number,
  :pr_oclc_number,
  :pr_publisher,
  :pr_place_of_pub,
  :pr_pub_date,
  :pr_bib_record,
  :pr_state_fk,
  :pr_rota_position,
  :pr_is_requester

  # Set the title on the index page
  index title: "Patron Requests"

end
