ActiveAdmin.register Borrowdirect::Reshare::HostLmsLocation,
as: "Reshare::HostLmsLocation",
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

  permit_params :hll_id, :origin, :hll_date_created, :hll_last_updated,
  :hll_version, :hll_code, :hll_name, :hll_supply_preference,
  :hll_corresponding_de, :hll_hidden

  # Set the title on the index page
  index title: "Host LMS Location"

end
