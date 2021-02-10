class RemoveJoinSectionFromReportTemplates < ActiveRecord::Migration[5.2]
  def change
    remove_column :report_templates, :join_section, :text
  end
end
