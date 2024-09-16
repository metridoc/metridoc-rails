ActiveAdmin.register Borrowdirect::Relais::ExceptionCode,
as: "Relais::ExceptionCode",
namespace: :borrowdirect do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('Relais', :borrowdirect_relais)
    ]
  end

  permit_params :exception_code,
  :exception_code_desc,
  :bd_exception_code_id,
  :version

  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  remove_filter :library_id

  # Set the title on the index page
  index title: "ExceptionCode"

end
