ActiveAdmin.register Borrowdirect::Relais::CallNumber,
as: "Relais::CallNumber",
namespace: :borrowdirect do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('Relais', :borrowdirect_relais)
    ]
  end

  permit_params :request_number, :holdings_seq, :supplier_code, :call_number,
  :process_date, :load_time, :call_number_id, :version

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :library_id

  # Set the title on the index page
  index title: "CallNumber"
end
