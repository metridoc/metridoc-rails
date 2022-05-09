ActiveAdmin.register Reshare::SupOverdue do
  menu false
  permit_params :so_supplier,
  :so_supplier_nice_name,
  :so_hrid,
  :so_title,
  :so_requester_sym,
  :so_supplier_url,
  :so_supplier_sym,
  :so_res_state,
  :so_due_date_rs,
  :so_local_call_number,
  :so_item_barcode,
  :so_last_updated

  preserve_default_filters!
  filter :so_supplier, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :so_supplier_nice_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
