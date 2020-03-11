class Tools::FileUploadImport < ApplicationRecord
  has_one_attached :uploaded_file
  belongs_to :uploaded_by, class_name: "AdminUser"

  before_create :set_defaults
  after_create  :queue_process

  UPLOADABLE_MODELS = [ Misc::ConsultationData,
  ]

  validates_presence_of :target_model, :uploaded_file

  def process
    return unless self.status.blank?

    file_path = ActiveStorage::Blob.service.send(:path_for, self.uploaded_file.key)
    table_name = self.target_model.constantize.table_name

    self.update_columns(last_attempted_at: Time.now, status: "in-progress")
    return_value = Import::Task.bulk_import(file_path, table_name)
    if return_value[0]
      self.update_columns(status: "success")
    else
      self.update_columns(status: "failed", last_error: return_value[1])
    end
  end

  private
  def set_defaults
    self.uploaded_at = Time.now if self.uploaded_at.blank?
  end

  def queue_process
    self.delay.process if self.status.blank? || self.status == 'pending'
  end

end
