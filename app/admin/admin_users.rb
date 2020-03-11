ActiveAdmin.register AdminUser do
  permit_params :email,
                :first_name,
                :last_name,
                :password,
                :password_confirmation,
                :super_admin,
                :user_role_id

  actions :all

  menu if: proc{ authorized?(:read, AdminUser) }, parent: I18n.t("phrases.security")

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column Security::UserRole.model_name.human do |admin_user|
      admin_user.user_role ? admin_user.user_role.name : ""
    end
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do |admin_user|
      attributes_table do
        row :first_name
        row :last_name
        row :email
        row :user_role_id
        row :super_admin
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
      f.input :user_role_id, as: :select, collection: Security::UserRole.all.map{|r| [r.name, r.id]}, include_blank: t("phrases.please_select")
      f.input :super_admin if current_admin_user.super_admin?
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
