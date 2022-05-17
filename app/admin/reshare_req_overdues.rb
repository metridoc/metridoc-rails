ActiveAdmin.register Reshare::ReqOverdue do
  menu false
  permit_params :ro_requester,
  :ro_requester_nice_name,
  :ro_hrid,
  :ro_title,
  :ro_requester_sym,
  :ro_requester_url,
  :ro_supplier_sym,
  :ro_req_state,
  :ro_due_date_rs,
  :ro_return_shipped_date,
  :ro_last_updated

  preserve_default_filters!
  filter :ro_requester, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :ro_requester_nice_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
