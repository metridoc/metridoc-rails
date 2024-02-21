ActiveAdmin.register Ezborrow::Reshare::PatronRequestAudit,
as: "Reshare::PatronRequestAudit",
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
  index title: "PatronRequestAudit"
end
