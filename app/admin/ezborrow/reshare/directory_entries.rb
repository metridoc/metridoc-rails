ActiveAdmin.register Ezborrow::Reshare::DirectoryEntry,
as: "Reshare::DirectoryEntry",
namespace: :ezborrow  do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('ReShare', :ezborrow_reshare)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]

  permit_params :origin,
  :de_id,
  :version,
  :de_slug,
  :de_name,
  :de_status_fk,
  :de_parent,
  :de_lms_location_code,
  :last_updated

  # Set the title on the index page
  index title: "DirectoryEntry"
end
