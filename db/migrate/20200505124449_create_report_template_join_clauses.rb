class CreateReportTemplateJoinClauses < ActiveRecord::Migration[5.2]
  def change
    create_table :report_template_join_clauses do |t|
      t.string :keyword
      t.string :table
      t.string :on_keys
      t.belongs_to :report_template, null: false, index: true

      t.timestamps null: false
    end
  end
end
