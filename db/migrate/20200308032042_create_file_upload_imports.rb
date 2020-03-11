class CreateFileUploadImports < ActiveRecord::Migration[5.1]
  def change

    create_table :file_upload_imports do |t|
      t.string   :target_model, null: false
      t.string   :comments
      t.integer  :uploaded_by_id
      t.datetime :uploaded_at, null: false

      t.string   :status
      t.datetime :last_attempted_at
      t.string   :last_error

      t.timestamps null: false
    end

  end
end
