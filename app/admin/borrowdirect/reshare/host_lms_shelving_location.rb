ActiveAdmin.register Borrowdirect::Reshare::HostLmsShelvingLocation,
as: "Reshare::HostLmsShelvingLocation",
namespace: :borrowdirect  do

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('ReShare', :borrowdirect_reshare)
    ]
  end

  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

  permit_params :hlsl_id, :origin, :hlsl_date_created, :hlsl_last_updated,
    :hlsl_version, :hlsl_code, :hlsl_name, :hlsl_supply_preference,
    :hlsl_hidden

  # Set the title on the index page
  index title: "Host LMS Shelving Location"

end
