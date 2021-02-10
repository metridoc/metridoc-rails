class AddNativeFullSqlToReportQuery < ActiveRecord::Migration[5.2]
  def change
    add_column :report_queries, :full_sql, :string
  end
end
