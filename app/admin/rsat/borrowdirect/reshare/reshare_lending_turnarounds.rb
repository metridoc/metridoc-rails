ActiveAdmin.register Rsat::Borrowdirect::Reshare::LendingTurnaround,
  as: "LendingTurnaround",
  namespace: :rsat  do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

end
