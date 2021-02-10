class AddSqlToFileUploadImports < ActiveRecord::Migration[5.2]
  def change
    add_column :file_upload_imports, :post_sql_to_execute, :string
  end
end
