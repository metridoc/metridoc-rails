ActiveAdmin.register Borrowdirect::Reshare::PatronRequestRota,
as: "Reshare::PatronRequestRota",
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
  :origin,
  :prr_id,
  :prr_version,
  :prr_date_created,
  :prr_last_updated,
  :prr_rota_position,
  :prr_directory_id_fk,
  :prr_patron_request_fk,
  :prr_state_fk,
  :prr_peer_symbol_fk,
  :prr_lb_score,
  :prr_lb_reason

  # Set the title on the index page
  index title: "Patron Request Rota"

end
