ActiveAdmin.register Reshare::PatronRequest do
  menu false
  permit_params :pr_id,
  :pr_version,
  :pr_patron_surname,
  :pr_date_created,
  :pr_pub_date,
  :pr_edition

  preserve_default_filters!
  filter :pr_patron_surname, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
