ActiveAdmin.register Security::UserRole, as: "UserRole" do
  menu if: proc{ authorized?(:read, Security::UserRole) }, parent: I18n.t("phrases.security")

  index do
    column :name
    actions
  end

  filter :name
  filter :created_at
  filter :updated_at

  permit_params :name,
                :user_role_access_definitions_attributes => [:id, :element, :access_level, :_destroy]

  show do |user_role|
      attributes_table do
        row :name
      end
      panel Security::UserRoleAccessDefinition.model_name.human(count: 2) do

        table_for user_role.user_role_access_definitions_sorted do
          column :element do |user_role_access_definition|
            user_role_access_definition.element_name
          end
          column :access_level do |user_role_access_definition|
            t("phrases.access_levels.#{user_role_access_definition.access_level}")
          end
        end

      end
  end

  form do |f|
    f.input :name

    f.has_many :user_role_access_definitions, for: [:user_role_access_definitions, f.object.user_role_access_definitions_sorted],
                                              heading: Security::UserRoleAccessDefinition.model_name.human(count: 2),
                                              allow_destroy: true,
                                              new_record: true do |a|
      a.input :element, as: :select, collection: Security::UserRole.select_options, include_blank: t("phrases.please_select")
      a.input :access_level, as: :radio, collection: Security::UserRole::ACCESS_LEVELS.map{|a| ["#{t("phrases.access_levels.#{a}")}", a]}, include_blank: false, label: false
    end

    f.actions
  end

end


