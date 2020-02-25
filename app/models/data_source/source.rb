class DataSource::Source < ApplicationRecord
  self.table_name = "data_source_sources"
  has_many :source_steps, foreign_key: "data_source_source_id", class_name: "DataSource::SourceStep"
  belongs_to :template, optional: true, foreign_key: "data_source_template_id", class_name: "DataSource::Template"

  before_create :copy_over_template_steps


  private
  def copy_over_template_steps
    return if self.template.blank?
    return if self.source_steps.present?

    self.template.template_steps.each do |template_step|
      self.source_steps.build( template_step.attributes.select{|x| DataSource::SourceStep.attribute_names.index(x) && x != "id"})
    end
  end

end
