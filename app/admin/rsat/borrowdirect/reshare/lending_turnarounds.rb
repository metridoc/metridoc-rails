ActiveAdmin.register Rsat::Borrowdirect::Reshare::LendingTurnaround,
as: "Borrowdirect::Reshare::LendingTurnaround",
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

end
