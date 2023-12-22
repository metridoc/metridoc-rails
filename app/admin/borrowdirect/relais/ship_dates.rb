ActiveAdmin.register Borrowdirect::Relais::ShipDate,
as: "Relais::ShipDate",
namespace: :borrowdirect do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('Relais', :borrowdirect_relais)
    ]
  end

  permit_params :request_number, :ship_date, :exception_code, :process_date,
  :ship_date_id, :load_time, :version

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :library_id

  # Set the title on the index page
  index title: "ShipDate"
end
