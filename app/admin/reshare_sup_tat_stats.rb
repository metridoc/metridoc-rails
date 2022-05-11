ActiveAdmin.register Reshare::RtatReq do
  menu false
  permit_params :stst_supplier,
    :stst_date_created,
    :stst_req_id,
    :stst_from_status,
    :stst_to_status,
    :stst_message

  preserve_default_filters!
  filter :stst_supplier, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
