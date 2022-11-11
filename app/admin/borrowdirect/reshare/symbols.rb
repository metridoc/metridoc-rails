ActiveAdmin.register Rsat::Borrowdirect::Reshare::Symbol,
as: "Borrowdirect::Reshare::Symbol",
namespace: :rsat do

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
    :sym_id,
    :sym_version,
    :sym_owner_fk,
    :sym_symbol

  # Set the title on the index page
  index title: "Symbols"

end
