ActiveAdmin.register_page "Policies" do
  menu false

  content title: proc{ I18n.t("active_admin.policies") } do
    div id: "dashboard_policies" do
      render partial: 'index'
    end
  end
end