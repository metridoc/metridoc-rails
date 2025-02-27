ActiveAdmin.register_page "Tutorials" do

  menu false

  content title: proc{ I18n.t("active_admin.tutorials") } do
    div id: "dashboard_tutorials" do
      render partial: 'index'
    end
  end

  # No need to obfuscate this page
end
