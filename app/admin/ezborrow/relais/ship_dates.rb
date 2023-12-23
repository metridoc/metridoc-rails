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

  permit_params :ship_date_id, :request_number, :ship_date, :exception_code,
  :process_date, :load_time, :version

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :library_id

  # Set the title on the index page
  index title: "ShipDate"
end
