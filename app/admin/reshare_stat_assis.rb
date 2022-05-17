ActiveAdmin.register Reshare::StatAssi do
  menu false
  permit_params :sta_supplier,
    :sta_date_created,
    :sta_req_id,
    :sta_from_status,
    :sta_to_status

  preserve_default_filters!
  filter :sta_supplier, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
