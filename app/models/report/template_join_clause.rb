class Report::TemplateJoinClause < ApplicationRecord
  validates_presence_of :keyword, :table, :on_keys
  belongs_to :report_template, class_name: "Report::Template"
  self.table_name = "report_template_join_clauses"
end
