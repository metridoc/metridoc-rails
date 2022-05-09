ActiveAdmin.register Reshare::SupStat do
  menu false
  permit_params :ss_supplier,
  :ss_supplier_nice_name,
  :ss_id,
  :ss_req_id,
  :ss_date_created,
  :ss_from_status,
  :ss_to_status,
  :ss_message

  preserve_default_filters!
  filter :ss_supplier, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
