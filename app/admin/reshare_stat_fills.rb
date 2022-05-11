ActiveAdmin.register Reshare::StatFill do
  menu false
  permit_params :stf_supplier,
    :stf_date_created,
    :stf_req_id,
    :stf_from_status,
    :stf_to_status

  preserve_default_filters!
  filter :stf_supplier, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
