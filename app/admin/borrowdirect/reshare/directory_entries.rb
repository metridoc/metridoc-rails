ActiveAdmin.register Rsat::Borrowdirect::Reshare::DirectoryEntry,
as: "Borrowdirect::Reshare::DirectoryEntry",
namespace: :rsat  do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('RSAT', :rsat_root),
      link_to('BorrowDirect', :rsat_borrowdirect),
      link_to('ReShare', :rsat_borrowdirect_reshare)
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
