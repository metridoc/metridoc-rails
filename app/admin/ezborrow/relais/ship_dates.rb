ActiveAdmin.register Ezborrow::Relais::ShipDate,
as: "Relais::ShipDate",
namespace: :ezborrow do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('Relais', :ezborrow_relais)
    ]
  end
  
  permit_params :ship_date_id, :request_number, :ship_date, :exception_code, :process_date, :load_time, :version
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :ship_date_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :request_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :ship_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :exception_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :process_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :load_time, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :version, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]


  # Set the title on the index page
  index title: "ShipDate"
end
