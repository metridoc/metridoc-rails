ActiveAdmin.register Borrowdirect::Reshare::Symbol,
as: "Reshare::Symbol",
namespace: :borrowdirect do

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
    :sym_id,
    :sym_version,
    :sym_owner_fk,
    :sym_symbol

  # Set the title on the index page
  index title: "Symbols"

end
