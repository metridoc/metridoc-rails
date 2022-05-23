ActiveAdmin.register_page "About" do

  menu false

  content title: proc{ I18n.t("active_admin.about") } do
    # Add a warning that people must get a user role if they do not have one
    unless current_admin_user.super_admin? or current_admin_user.user_role
      div id: "warning" do
        render partial: 'no_role'
      end
    end

    # Provide contact information for people who have a user role, but are not super admins
    if !current_admin_user.super_admin? and current_admin_user.user_role
      div id: "info" do
        render partial: 'non_super_admin'
      end
    end

    # The basic about page
    div id: "dashboard_about" do
      render partial: 'index'
    end
  end
end
