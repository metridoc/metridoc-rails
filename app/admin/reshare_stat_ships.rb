ActiveAdmin.register Reshare::StatShip do
  menu false
  permit_params :sts_supplier,
    :sts_date_created,
    :sts_req_id,
    :sts_from_status,
    :sts_to_status


  preserve_default_filters!
  filter :sts_supplier, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
