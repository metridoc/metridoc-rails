ActiveAdmin.register_page "About" do

  menu priority: 14, label: proc{ I18n.t("active_admin.about") }

  content title: proc{ I18n.t("active_admin.about") } do
    div id: "dashboard_about" do
      render partial: 'index'
    end
  end
end