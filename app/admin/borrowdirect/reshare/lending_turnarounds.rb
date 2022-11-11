ActiveAdmin.register Borrowdirect::Reshare::LendingTurnaround,
as: "Reshare::LendingTurnaround",
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

  # Set the title on the index page
  index title: "Lending Turnarounds"

end
