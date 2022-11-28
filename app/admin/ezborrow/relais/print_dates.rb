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
  
  permit_params :print_date_id, :request_number, :print_date, :note, :process_date, :load_time, :library_id, :version
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :print_date_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :request_number, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :print_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :note, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :process_date, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :load_time, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :library_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :version, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]


  # Set the title on the index page
  index title: "PrintDate"
end
