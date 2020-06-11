class CreateFileUploadImports < ActiveRecord::Migration[5.1]
  def change

    create_table :file_upload_imports do |t|
      t.string   :target_model, null: false
      t.string   :comments
      t.integer  :uploaded_by_id
      t.datetime :uploaded_at, null: false

      t.string   :status
      t.datetime :last_attempted_at

      t.timestamps null: false
    end

    create_table :file_upload_import_logs do |t|
      t.belongs_to :file_upload_import, null: false, index: true
      t.datetime   :log_datetime, null: false
      t.string     :log_text
      t.integer    :sequence, null: false
    end
    add_foreign_key :file_upload_import_logs, :file_upload_imports

  end
end
