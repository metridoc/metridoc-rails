ActiveAdmin.register Borrowdirect::Reshare::DirectoryEntry,
as: "Reshare::DirectoryEntry",
namespace: :borrowdirect  do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('ReShare', :borrowdirect_reshare)
    ]
  end

  menu false
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

  preserve_default_filters!
  filter :de_slug, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

  # Set the title on the index page
  index title: "Directory Entries"

end
