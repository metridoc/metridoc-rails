ActiveAdmin.register Rsat::Borrowdirect::Reshare::BorrowingTurnaround,
as: "Borrowdirect::Reshare::BorrowingTurnaround",
namespace: :rsat do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('RSAT', :rsat_root),
      link_to('BorrowDirect', :rsat_borrowdirect),
      link_to('ReShare', :rsat_borrowdirect_reshare)
    ]
  end

  # Don't add to the drop down menus
  menu false

  # Don't allow users to modify or delete tables
  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "Borrowing Turnarounds"

end
