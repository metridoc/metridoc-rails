ActiveAdmin.register LibraryProfile::Profile do
  menu false
  permit_params :metridoc_code, :oclc_symbol, :bd_symbol, :docline_symbol, :institution_name, :library_name, :name_symbol, :also_called, :zip_code_location, :country, :null_ignore, :palci, :trln, :btaa, :gwla, :blc, :aserl, :viva, :bd
  actions :all, :except => [:new, :edit, :update, :destroy]

  controller do
    before_action { @page_title = I18n.t("active_admin.library_profile.library_profile_menu") }
  end

  preserve_default_filters!

  filter :metridoc_code, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :oclc_symbol, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :bd_symbol, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :docline_symbol, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :institution_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :library_name, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :name_symbol, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :also_called, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :zip_code_location, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :country, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :null_ignore, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :palci, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :trln, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :btaa, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :gwla, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :blc, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :aserl, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :viva, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]
  filter :bd, filters: [:contains, :not_cont, :starts_with, :ends_with, :equals]


end