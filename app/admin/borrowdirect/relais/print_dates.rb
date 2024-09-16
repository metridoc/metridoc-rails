ActiveAdmin.register Borrowdirect::Relais::PrintDate,
as: "Relais::PrintDate",
namespace: :borrowdirect do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('Relais', :borrowdirect_relais)
    ]
  end

  permit_params :request_number, :print_date, :note, :process_date,
  :print_date_id, :load_time, :library_id, :version

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "PrintDate"
end
