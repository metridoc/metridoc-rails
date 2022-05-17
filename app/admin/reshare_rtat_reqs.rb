ActiveAdmin.register Reshare::RtatReq do
  menu false
  permit_params :rtr_requester,
  :rtr_requester_nice_name,
  :rtr_hrid,
  :rtr_title,
  :rtr_call_number,
  :rtr_barcode,
  :rtr_supplier,
  :rtr_supplier_nice_name ,
  :rtr_date_created,
  :rtr_id

  preserve_default_filters!
  filter :rtr_requester, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :rtr_requester_nice_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
