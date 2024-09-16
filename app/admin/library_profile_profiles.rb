ActiveAdmin.register LibraryProfile::Profile do
  menu false
  permit_params :metridoc_code,
  :oclc_symbol,
  :bd_symbol,
  :docline_symbol,
  :institution_name,
  :library_name,
  :name_symbol,
  :also_called,
  :zip_code_location,
  :country,
  :null_ignore,
  :palci,
  :trln,
  :btaa,
  :gwla,
  :blc,
  :aserl,
  :viva,
  :bd
  actions :all, :except => [:new, :edit, :update, :destroy]

  controller do
    before_action { @page_title = I18n.t("active_admin.library_profiles.profiles") }
  end
end
