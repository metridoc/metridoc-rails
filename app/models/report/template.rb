class Report::Template < ApplicationRecord
  serialize :select_section, Array
  serialize :group_by_section, Array
  attr_accessor :select_section_with_aggregates
  attr_reader :join_section
  self.table_name = "report_templates"

  before_save :remove_select_section_bad_data
  before_save :remove_group_by_section_bad_data

  validates :name, presence: true, uniqueness: true

  has_many :report_template_join_clauses, foreign_key: "report_template_id", class_name: "Report::TemplateJoinClause", dependent: :destroy, inverse_of: :report_template
  accepts_nested_attributes_for :report_template_join_clauses, allow_destroy: true, reject_if: proc {|attributes| attributes['keyword'].blank? || attributes['table'].blank? || attributes['on_keys'].blank? }
  alias join_clauses report_template_join_clauses

  def remove_select_section_bad_data
    if select_section.first.blank? || select_section.first.include?('Select Section')
      updated_select_section = select_section
      updated_select_section.shift
      self.select_section = updated_select_section
    end
  end

  def remove_group_by_section_bad_data
    if group_by_section.first == ''
      updated_group_by_section = group_by_section
      updated_group_by_section.shift
      self.group_by_section = updated_group_by_section
    end
  end

  def checkbox_options_for_select_section
    full_field_names = TableRetrieval.attributes(table_names)[:table_attributes].map do |key,values|
      values.map{|value|"#{key}.#{value}"}
    end.flatten
    if full_field_names.blank?
      []
    else
      fields = ["*"] + full_field_names
      fields.map do |attribute_name|
        [attribute_name, attribute_name, {checked: select_section && select_section.include?(attribute_name)}]
      end
    end
  end

  def radio_options_for_group_by_section
    if group_by_section.any?
      full_field_names = TableRetrieval.attributes(table_names)[:table_attributes].map do |key,values|
        values.map{|value|"#{key}.#{value}"}
      end.flatten
      full_field_names.map do |attribute_name|
        [attribute_name, attribute_name, {checked: group_by_section && group_by_section.include?(attribute_name)}]
      end
    end
  end

  def radio_options_for_order_section
    if id.nil?
      []
    else
      full_field_names = TableRetrieval.attributes(table_names)[:table_attributes].map do |key,values|
        values.map{|value|"#{key}.#{value}"}
      end.flatten
      full_field_names.map do |attribute_name|
        [attribute_name, attribute_name, {checked: order_section && order_section.include?(attribute_name)}]
      end
    end
  end

  def select_section_with_aggregates
    select_section
  end

  def join_section
    join_statement = ""
    join_clauses.each do |join_clause|
      join_statement += "#{join_clause.keyword} #{join_clause.table} ON #{join_clause.on_keys} "
    end
    join_statement.strip
  end

  private
  def table_names
    tables = []
    tables << from_section
    if join_clauses.any?
      join_section_tables = join_clauses.pluck(:table)
      tables << join_section_tables
    end
    tables.compact.uniq.join(",")
  end
end
