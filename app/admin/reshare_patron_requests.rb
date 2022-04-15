ActiveAdmin.register Reshare::PatronRequest do
  menu false
  permit_params :pr_id, :pr_version, :pr_patron_surname

  filter :pr_patron_surname, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
