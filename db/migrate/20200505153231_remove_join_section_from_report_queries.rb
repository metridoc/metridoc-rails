class RemoveJoinSectionFromReportQueries < ActiveRecord::Migration[5.2]
  def change
    remove_column :report_queries, :join_section, :text
  end
end
