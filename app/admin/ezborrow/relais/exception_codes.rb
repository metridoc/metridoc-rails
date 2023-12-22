ActiveAdmin.register Ezborrow::Relais::ExceptionCode,
as: "Relais::ExceptionCode",
namespace: :ezborrow do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('EzBorrow', :ezborrow_root),
      link_to('Relais', :ezborrow_relais)
    ]
  end

  permit_params :exception_code,
  :exception_code_desc,
  :ezb_exception_code_id,
  :version

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :library_id

  # Set the title on the index page
  index title: "ExceptionCode"
end
