ActiveAdmin.register Ezborrow::Relais::PatronType,
as: "Relais::PatronType",
namespace: :ezborrow do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('Relais', :ezborrow_relais)
    ]
  end

  permit_params :patron_type, :patron_type_desc, :ezb_patron_type_id
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :library_id

  # Set the title on the index page
  index title: "PatronType"
end
