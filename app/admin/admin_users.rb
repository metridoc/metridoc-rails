ActiveAdmin.register AdminUser do
  permit_params do
              [
                :email,
                :first_name,
                :last_name,
                :password,
                :password_confirmation,
                current_admin_user.super_admin? ? :super_admin : nil,
                current_admin_user.authorized?('read-write', "Security") ? :user_role_id : nil,
              ]
  end

  actions :all

  menu if: proc{ authorized?(:read, AdminUser) }, parent: I18n.t("phrases.admin")

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column Security::UserRole.model_name.human do |admin_user|
      admin_user.user_role ? admin_user.user_role.name : ""
    end
    column :super_admin
    column :last_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  config.action_items.delete_if { |item| item.display_on?(:show) }

  action_item :edit,
              only: :show,
              if: proc{ current_admin_user != resource && current_admin_user.authorized?('read-write', AdminUser) } do
    link_to "#{I18n.t('active_admin.edit_resource', resource: AdminUser.model_name.human)}", edit_resource_path(resource)
  end
  action_item :destroy,
              only: :show,
              if: proc{ current_admin_user != resource && current_admin_user.authorized?('read-write', AdminUser) } do
    link_to "#{I18n.t('active_admin.delete_resource', resource: AdminUser.model_name.human)}", resource_path(resource), method: :delete, data: {confirm: I18n.t("phrases.are_you_sure") }
  end

  show do |admin_user|
      attributes_table do
        row :first_name
        row :last_name
        row :email
        row :user_role_id do
          admin_user.user_role_id.present? ? admin_user.user_role.name : "-"
        end
        row :super_admin if current_admin_user.super_admin?
      end
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :user_role_id, as: :select, collection: Security::UserRole.all.map{|r| [r.name, r.id]}, include_blank: t("phrases.please_select") if current_admin_user.authorized?('read-write', "Security")
      f.input :super_admin if current_admin_user.super_admin?
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  collection_action :edit_profile, method: :get do
    render "edit_profile"
  end

end
