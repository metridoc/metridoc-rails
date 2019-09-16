ActiveAdmin.register Ezborrow::ExceptionCode do
  menu false
  permit_params :exception_code, :exception_code_desc, :ezb_exception_code_id, :version
  actions :all, :except => [:new, :edit, :update, :destroy]

  preserve_default_filters!

  filter :exception_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :exception_code_desc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :ezb_exception_code_id, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :version, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end
