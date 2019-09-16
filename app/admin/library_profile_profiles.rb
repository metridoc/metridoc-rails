ActiveAdmin.register LibraryProfile::Profile do
  menu false
  permit_params :institution_name, :library_name, :zip_code, :country, :oclc_symbol, :docline_symbol, :borrowdirect_symbol, :null_ignore, :palci, :trln, :btaa, :gwla, :blc, :aserl, :viva
  actions :all, :except => [:new, :edit, :update, :destroy]

  controller do
    before_action { @page_title = I18n.t("active_admin.library_profiles.profiles") }
  end

  preserve_default_filters!

  filter :institution_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :library_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :zip_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :country, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :oclc_symbol, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :docline_symbol, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :borrowdirect_symbol, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :null_ignore, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :palci, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :trln, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :btaa, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :gwla, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :blc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :aserl, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :viva, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]

end