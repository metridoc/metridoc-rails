class Report::Query < ApplicationRecord
  self.table_name = "report_queries"

  belongs_to :owner, class_name: "AdminUser"


end
