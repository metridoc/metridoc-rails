class CreateEzpaarseJobTable < ActiveRecord::Migration[5.2]
  def change
    create_table :ezpaarse_jobs do |t|
      t.string :file_name
      t.date :log_date
      t.boolean :successful_import
      t.integer :records_imported
    end
  end
end
