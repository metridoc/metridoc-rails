ActiveAdmin.register Reshare::StatRec do
  menu false
  permit_params :stre_supplier,
    :stre_date_created,
    :stre_req_id,
    :stre_from_status,
    :stre_to_status

  preserve_default_filters!
  filter :stre_supplier, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
