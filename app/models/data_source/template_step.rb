class DataSource::TemplateStep < ApplicationRecord
  self.table_name = "data_source_template_steps"
  belongs_to :templates, foreign_key: "data_source_template_id", class_name: "DataSource::Template"

end
