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
        

        table_for user_role.user_role_access_definitions do
          column :element do |user_role_access_definition|
            user_role_access_definition.element.constantize.model_name.human(count:2)
          end
          column :access_level do |user_role_access_definition|
            t("phrases.access_levels.#{user_role_access_definition.access_level}")
          end
        end
      end
  end

  form do |f|
    f.input :name

    f.inputs do
      f.has_many :user_role_access_definitions, heading: Security::UserRoleAccessDefinition.model_name.human(count: 2),
                                                allow_destroy: true,
                                                new_record: true do |a|
        a.input :element, as: :select, collection: Security::UserRole::MANAGED_ELEMENTS.map{|e| ["#{e.model_name.human(count: 2)}", e]}, include_blank: t("phrases.please_select")
        a.input :access_level, as: :radio, collection: Security::UserRole::ACCESS_LEVELS.map{|a| ["#{t("phrases.access_levels.#{a}")}", a]}, include_blank: false, label: false
      end
    end

    f.actions
  end

  # show do |source|
  #     attributes_table do
  #       row :name
  #       row :institution_code
  #       row :source_adapter
  #       row :batch_size
  #       row :host
  #       row :port
  #       row :database
  #       row :username
  #       row :password
  #       row :export_folder
  #       row :import_folder
  #       row :batch_size
  #     end
  #     panel DataSource::SourceStep.model_name.human(count: 2) do
  #       table_for source.source_steps.order(:load_sequence) do
  #         column :load_sequence
  #         column :name
  #
  #         column do |source_step|
  #           link_to "View", admin_source_source_step_path(source, source_step)
  #         end
  #
  #       end
  #     end
  # end
  #
  # permit_params :name,
  #               :data_source_template_id,
  #               :institution_code,
  #               :source_adapter,
  #               :host,
  #               :port,
  #               :database,
  #               :username,
  #               :password,
  #               :export_folder,
  #               :import_folder,
  #               :batch_size

end


