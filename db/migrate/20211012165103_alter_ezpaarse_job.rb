class AlterEzpaarseJob < ActiveRecord::Migration[5.2]
  def change
    remove_column :ezpaarse_jobs, :successful_import, :boolean
    remove_column :ezpaarse_jobs, :records_imported, :integer
    add_column :ezpaarse_jobs, :message, :text
    add_column :ezpaarse_jobs, :run_date, :datetime
  end
end
