ActiveAdmin.register Reshare::PatronRequestAudit do
  menu false
  permit_params :last_updated,
    :origin,
    :pra_id,
    :pra_version,
    :pra_date_created,
    :pra_patron_request_fk,
    :pra_from_status,
    :pra_to_status,
    :pra_message
end
