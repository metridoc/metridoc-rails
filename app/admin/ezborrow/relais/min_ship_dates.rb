ActiveAdmin.register Ezborrow::Relais::MinShipDate,
as: "Relais::MinShipDate",
namespace: :ezborrow do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('Relais', :ezborrow_relais)
    ]
  end

  permit_params :request_number, :min_ship_date
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :request_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :min_ship_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]


  # Set the title on the index page
  index title: "MinShipDate"
end
