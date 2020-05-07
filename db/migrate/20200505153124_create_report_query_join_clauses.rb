class CreateReportQueryJoinClauses < ActiveRecord::Migration[5.2]
  def change
    create_table :report_query_join_clauses do |t|
      t.string :keyword
      t.string :table
      t.string :on_keys
      t.belongs_to :report_query, null: false, index: true

      t.timestamps null: false
    end
  end
end
