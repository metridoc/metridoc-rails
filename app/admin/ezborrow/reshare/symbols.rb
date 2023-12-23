ActiveAdmin.register Ezborrow::Reshare::Symbol,
as: "Reshare::Symbol",
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

  permit_params :last_updated,
  :origin,
  :sym_id,
  :sym_version,
  :sym_owner_fk,
  :sym_symbol

  # Set the title on the index page
  index title: "Symbol"
end
