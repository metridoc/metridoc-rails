ActiveAdmin.register_page "SQL Syntax" do

  menu false

  content title: proc{ I18n.t("active_admin.tutorials") } do
    div id: "dashboard_sql" do
      render partial: 'admin/tutorials/sql_syntax'
    end
  end

  # No need to obfuscate this page
end
