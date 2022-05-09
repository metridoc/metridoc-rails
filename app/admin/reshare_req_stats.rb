ActiveAdmin.register Reshare::ReqStat do
  menu false
  permit_params :rs_requester,
  :rs_requester_nice_name,
  :rs_id,
  :rs_req_id,
  :rs_date_created,
  :rs_from_status,
  :rs_to_status,
  :rs_message

  preserve_default_filters!
  filter :rs_requester, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
