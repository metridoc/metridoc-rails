class AddNcbiCrossrefToEzproxyLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :ezpaarse_logs, :title, :string
    add_column :ezpaarse_logs, :type, :string
    add_column :ezpaarse_logs, :subject, :string
    add_column :ezpaarse_logs, :license, :string
    change_column :ezpaarse_logs, :size, :bigint
  end
end
