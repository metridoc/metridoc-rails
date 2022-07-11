ActiveAdmin.register_page "Dashboard", namespace: :ipeds do
  menu false

  content title: I18n.t("active_admin.ipeds.ipeds_dashboard") do
    render partial: 'dashboard'
  end
end
