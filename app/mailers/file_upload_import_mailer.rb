class FileUploadImportMailer < ApplicationMailer

  def started_notice
    @file_upload_import = params[:file_upload_import]
    @uploaded_by = @file_upload_import.uploaded_by
    mail(to: @uploaded_by.email, subject: 'File Upload Started')
  end

  def finished_notice
    @file_upload_import = params[:file_upload_import]
    @uploaded_by = @file_upload_import.uploaded_by
    mail(to: @uploaded_by.email, subject: 'File Upload Finished')
  end

end
