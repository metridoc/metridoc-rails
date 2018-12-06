ActiveAdmin.register Ezborrow::ExceptionCode do
  menu false
  permit_params :exception_code, :exception_code_desc, :ezb_exception_code_id, :version
  actions :all, :except => [:edit, :update, :destroy]
end
