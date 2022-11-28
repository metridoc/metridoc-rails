ActiveAdmin.register Borrowdirect::Reshare::BorrowingTurnaround,
as: "Reshare::BorrowingTurnaround",
namespace: :borrowdirect do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('ReShare', :borrowdirect_reshare)
    ]
  end

  # Don't add to the drop down menus
  menu false

  # Don't allow users to modify or delete tables
  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "Borrowing Turnarounds"

end
