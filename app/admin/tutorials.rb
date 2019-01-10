ActiveAdmin.register_page "Tutorials" do

  menu priority: 16, label: proc{ I18n.t("active_admin.tutorials") }

  content title: proc{ I18n.t("active_admin.tutorials") } do
    div id: "dashboard_tutorials" do
      render partial: 'index'
    end
  end
end