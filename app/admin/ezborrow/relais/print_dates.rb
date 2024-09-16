ActiveAdmin.register Ezborrow::Relais::PrintDate,
as: "Relais::PrintDate",
namespace: :ezborrow do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('Relais', :ezborrow_relais)
    ]
  end

  permit_params :print_date_id, :request_number, :print_date, :note,
  :process_date, :load_time, :library_id, :version
  
  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "PrintDate"
end
