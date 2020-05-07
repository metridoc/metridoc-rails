class Report::QueryJoinClause < ApplicationRecord
  validates_presence_of :keyword, :table, :on_keys
  belongs_to :report_query, class_name: "Report::Query"
  self.table_name = "report_query_join_clauses"
end
