ActiveAdmin.register Reshare::PatronRequest do
  menu false
  permit_params :pr_id,
  :pr_version,
  :pr_date_created,
  :pr_pub_date,
  :pr_edition

  preserve_default_filters!

end
