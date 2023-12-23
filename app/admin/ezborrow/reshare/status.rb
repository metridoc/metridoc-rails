ActiveAdmin.register Ezborrow::Reshare::Status,
as: "Reshare::Status",
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
  :st_id,
  :st_version,
  :st_code

  # Set the title on the index page
  index title: "Status"
end
