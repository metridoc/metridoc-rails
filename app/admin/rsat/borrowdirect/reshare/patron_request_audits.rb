ActiveAdmin.register Rsat::Borrowdirect::Reshare::PatronRequestAudit,
as: "Borrowdirect::Reshare::PatronRequestAudit",
namespace: :rsat  do

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

  permit_params :last_updated,
    :origin,
    :pra_id,
    :pra_version,
    :pra_date_created,
    :pra_patron_request_fk,
    :pra_from_status_fk,
    :pra_to_status_fk,
    :pra_message
end
