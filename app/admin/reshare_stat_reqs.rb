ActiveAdmin.register Reshare::StatReq do
  menu false
  permit_params :str_supplier,
    :str_supplier_nice_name,
    :str_hrid,
    :str_title,
    :str_call_number,
    :str_barcode,
    :str_requester,
    :str_requester_nice_name,
    :str_date_created,
    :str_id

  preserve_default_filters!
  filter :str_title, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
