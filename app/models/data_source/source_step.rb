class DataSource::SourceStep < ApplicationRecord
  self.table_name = "data_source_source_steps"
  belongs_to :source, foreign_key: "data_source_source_id", class_name: "DataSource::Source"

end
