ActiveAdmin.register LibraryProfile::Profile do
  menu false
  permit_params :institution_name, :library_name, :zip_code, :country, :oclc_symbol, :docline_symbol, :borrowdirect_symbol, :null_ignore, :palci, :trln, :btaa, :gwla, :blc, :aserl, :viva
  actions :all, :except => [:new, :edit, :update, :destroy]

  controller do
    before_action { @page_title = I18n.t("active_admin.library_profiles.profiles") }
  end
end