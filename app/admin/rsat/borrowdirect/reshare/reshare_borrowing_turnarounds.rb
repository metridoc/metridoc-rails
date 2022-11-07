ActiveAdmin.register Rsat::Borrowdirect::Reshare::BorrowingTurnaround,
  as: "BorrowingTurnaround",
  namespace: :rsat do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

end
