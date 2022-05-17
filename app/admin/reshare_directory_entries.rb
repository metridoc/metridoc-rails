ActiveAdmin.register Reshare::DirectoryEntry do
  menu false
  permit_params :origin,
  :de_id,
  :version,
  :custom_properties_id,
  :de_slug,
  :de_foaf_timestamp,
  :de_foaf_url,
  :de_name,
  :de_status_fk,
  :de_desc,
  :de_parent,
  :de_lms_location_code,
  :de_entry_url,
  :de_phone_number,
  :de_email_address,
  :de_contact_name,
  :de_type_rv_fk,
  :de_published_last_update,
  :de_branding_url

  preserve_default_filters!
  filter :de_slug, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
