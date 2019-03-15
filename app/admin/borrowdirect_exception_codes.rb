ActiveAdmin.register Borrowdirect::ExceptionCode do
  menu false
  permit_params :exception_code, :exception_code_desc, :bd_exception_code_id, :version
  actions :all, :except => [:new, :edit, :update, :destroy]
end
