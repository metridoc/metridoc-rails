ActiveAdmin.register Ezborrow::Reshare::BorrowingTurnaround,
as: "Reshare::BorrowingTurnaround",
namespace: :ezborrow do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('ReShare', :ezborrow_reshare)
    ]
  end

  actions :all, :except => [:new, :edit, :update, :destroy]


  # Set the title on the index page
  index title: "BorrowingTurnaround"

end
