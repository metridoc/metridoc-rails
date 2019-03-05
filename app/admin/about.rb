ActiveAdmin.register_page "About" do

  menu false

  content title: proc{ I18n.t("active_admin.about") } do
    div id: "dashboard_about" do
      render partial: 'index'
    end
  end
end