ActiveAdmin.register Tools::FileUploadImport do
  actions :all

  menu if: proc{ authorized?(:read, Tools::FileUploadImport) }, parent: I18n.t("phrases.tools")

  permit_params :target_model,
                :uploaded_file,
                :comments

  form do |f|
    f.inputs do
      f.input :target_model, as: :select, collection: Tools::FileUploadImport::UPLOADABLE_MODELS.collect{|m| [m.model_name.human, m.to_s]}, include_blank: I18n.t("phrases.please_select")
      f.input :uploaded_file, as: :file
      f.input :comments
      f.actions
    end
  end

  show do |file_upload_import|
      attributes_table do
        row :target_model do
          file_upload_import.target_model.constantize.model_name.human
        end
        row :comments
        row :uploaded_by do
          file_upload_import.uploaded_by ? file_upload_import.uploaded_by.full_name : "-"
        end
        row :uploaded_at do
          I18n.l(file_upload_import.uploaded_at)
        end
        row :uploaded_file do
          link_to file_upload_import.uploaded_file.filename, url_for(file_upload_import.uploaded_file), target: '_blank'
        end
        row :status do
          file_upload_import.status.blank? ? I18n.t("phrases.file_upload_import.statuses.pending") : I18n.t("phrases.file_upload_import.statuses.#{file_upload_import.status}")
        end
        row :last_attempted_at do
          file_upload_import.last_attempted_at.blank? ? "-" : I18n.l(file_upload_import.last_attempted_at)
        end
        row :last_error do
          file_upload_import.last_error.blank? ? "-" : file_upload_import.last_error
        end
      end
  end

  filter :target_model, as: :select, collection: Tools::FileUploadImport::UPLOADABLE_MODELS.collect{|m| [m.model_name.human, m.to_s]}
  filter :comments

  scope('Default', default: true) { |scope| scope.where(uploaded_by_id: current_admin_user.id) }

  index do
    column :target_model do |file_upload_import|
      file_upload_import.target_model.constantize.model_name.human
    end
    column :uploaded_file do |file_upload_import|
      link_to file_upload_import.uploaded_file.filename, url_for(file_upload_import.uploaded_file), target: '_blank'
    end
    column :uploaded_by do |file_upload_import|
      file_upload_import.uploaded_by ? file_upload_import.uploaded_by.full_name : "-"
    end
    column :uploaded_at do |file_upload_import|
      I18n.l(file_upload_import.uploaded_at)
    end
    column :status do |file_upload_import|
      file_upload_import.status.blank? ? I18n.t("phrases.file_upload_import.statuses.pending") : I18n.t("phrases.file_upload_import.statuses.#{file_upload_import.status}")
    end
    column :last_attempted_at do |file_upload_import|
      file_upload_import.last_attempted_at.blank? ? "-" : I18n.l(file_upload_import.last_attempted_at)
    end
    actions
  end

  before_create do |file_upload_import|
    file_upload_import.uploaded_by = current_admin_user
  end

end
