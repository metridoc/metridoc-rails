ActiveAdmin.register Reshare::RtatRec do
  menu false
  permit_params :rtre_requester, :rtre_date_created, :rtre_req_id, :rtre_status

  filter :rtre_requester, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
