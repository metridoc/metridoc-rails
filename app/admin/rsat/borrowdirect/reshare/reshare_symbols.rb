ActiveAdmin.register Rsat::Borrowdirect::Reshare::Symbol,
  as: "Symbol",
  namespace: :rsat  do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

  permit_params :last_updated,
    :origin,
    :sym_id,
    :sym_version,
    :sym_owner_fk,
    :sym_symbol
end
