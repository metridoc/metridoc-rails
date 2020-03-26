class Tools::FileUploadImportLog < ApplicationRecord
  belongs_to :file_upload_import, class_name: "Tools::FileUploadImport"

  before_create :set_defaults

  private
  def set_defaults
    self.log_datetime = Time.now if self.log_datetime.blank?
  end

end
