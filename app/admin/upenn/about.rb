ActiveAdmin.register_page "About", namespace: :upenn do
  menu false
  content title: I18n.t("active_admin.upenn.upenn_menu") do
    render partial: 'index'
  end
end
