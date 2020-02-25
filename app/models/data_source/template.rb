class DataSource::Template < ApplicationRecord
  self.table_name = "data_source_templates"
  has_many :template_steps, foreign_key: "data_source_template_id", class_name: "DataSource::TemplateStep"

end
