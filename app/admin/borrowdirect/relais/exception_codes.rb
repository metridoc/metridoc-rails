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

  permit_params :exception_code, :exception_code_desc, :bd_exception_code_id, :version
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!
  filter :exception_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :exception_code_desc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :bd_exception_code_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :version, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

  # Set the title on the index page
  index title: "ExceptionCode"

end
