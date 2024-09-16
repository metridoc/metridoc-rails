ActiveAdmin.register Borrowdirect::Reshare::Status,
as: "Reshare::Status",
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

  permit_params :last_updated,
  :origin,
  :st_id,
  :st_version,
  :st_code

  # Set the title on the index page
  index title: "Status"

end
