ActiveAdmin.register Reshare::RtatShip do
  menu false
  permit_params :rts_requester, :rts_date_created, :rts_req_id, :rts_from_status, :rts_to_status

  filter :rts_requester, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
