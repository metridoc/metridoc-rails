class AddProgressFieldsToReportQuery < ActiveRecord::Migration[5.2]
  def change

    add_column :report_queries, :total_rows_to_process, :integer
    add_column :report_queries, :n_rows_processed, :integer

  end
end
