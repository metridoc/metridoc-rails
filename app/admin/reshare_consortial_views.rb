ActiveAdmin.register Reshare::ConsortialView do
  menu false
  permit_params :cv_requester, :cv_requester_nice_name, :cv_date_created, :cv_last_updated, :cv_supplier_nice_name, :cv_patron_request_fk, :cv_state_fk, :cv_code

  filter :cv_requester, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :cv_requester_nice_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
end
