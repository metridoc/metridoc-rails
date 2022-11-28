ActiveAdmin.register Borrowdirect::Reshare::PatronRequestAudit,
as: "Reshare::PatronRequestAudit",
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
    :pra_id,
    :pra_version,
    :pra_date_created,
    :pra_patron_request_fk,
    :pra_from_status_fk,
    :pra_to_status_fk,
    :pra_message

  # Set the title on the index page
  index title: "Patron Request Audits"

end
