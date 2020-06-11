class AddFullSqlToReportTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :report_templates, :full_sql, :string
  end
end
