class FileUploadImportChanges < ActiveRecord::Migration[5.2]
  def change
    
    add_column :file_upload_imports, :total_rows_to_process, :integer
    add_column :file_upload_imports, :n_rows_processed, :integer

  end
end
