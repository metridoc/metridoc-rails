class Report::QueryJoinClause < ApplicationRecord
  validates :keyword, :table, :on_keys, presence: true
  belongs_to :report_query, class_name: "Report::Query"
  self.table_name = "report_query_join_clauses"
end
