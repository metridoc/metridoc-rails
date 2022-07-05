ActiveAdmin.register Security::UserRole, as: "UserRole" do
  menu if: proc{ authorized?(:read, Security::UserRole) }, parent: I18n.t("phrases.admin")

  index do
    column :name
    actions
  end

  filter :name
  filter :created_at
  filter :updated_at

  permit_params :name,
                :user_role_sections_attributes => [:id, :section, :access_level, :_destroy]

  show do |user_role|
      attributes_table do
        row :name
      end
      panel Security::UserRoleSection.model_name.human(count: 2) do

        table_for user_role.user_role_sections_sorted do
          column :section do |user_role_section|
            user_role_section.section_name
          end
          column :access_level do |user_role_section|
            t("phrases.access_levels.#{user_role_section.access_level}")
          end
        end

      end
  end

  form do |f|
    f.input :name

    f.has_many :user_role_sections, for: [:user_role_sections, f.object.user_role_sections_sorted],
                                              heading: Security::UserRoleSection.model_name.human(count: 2),
                                              allow_destroy: true,
                                              new_record: true do |a|
      a.input :section, as: :select, collection: Security::UserRole.section_select_options, include_blank: t("phrases.please_select")
      a.input :access_level, as: :radio, collection: Security::UserRole::ACCESS_LEVELS.map{|a| ["#{t("phrases.access_levels.#{a}")}", a]}, include_blank: false, label: false
    end

    f.actions
  end

end


