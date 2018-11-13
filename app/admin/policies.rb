ActiveAdmin.register_page "Policies" do

  menu priority: 15, label: proc{ I18n.t("active_admin.policies") }

  content title: proc{ I18n.t("active_admin.policies") } do
    div id: "dashboard_policies" do
      render partial: 'index'
    end
  end
end