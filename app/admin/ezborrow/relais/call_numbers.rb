ActiveAdmin.register Ezborrow::Relais::CallNumber,
as: "Relais::CallNumber",
namespace: :ezborrow do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('Relais', :ezborrow_relais)
    ]
  end

  permit_params :call_number_id, :request_number, :holdings_seq, :supplier_code,
  :call_number, :process_date, :load_time, :version

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :library_id

  # Set the title on the index page
  index title: "CallNumber"
end
