ActiveAdmin.register Rsat::Borrowdirect::Reshare::Status,
as: "Borrowdirect::Reshare::Status",
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

  permit_params :last_updated,
    :origin,
    :st_id,
    :st_version,
    :st_code

  # Set the title on the index page
  index title: "Status"

end
