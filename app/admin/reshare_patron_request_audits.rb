ActiveAdmin.register Reshare::PatronRequestAudit do
  menu false
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
