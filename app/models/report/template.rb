class Report::Template < ApplicationRecord
  serialize :select_section, Array
  serialize :group_by_section, Array
  serialize :order_section, Array
  attr_accessor :select_section_with_aggregates
  self.table_name = "report_templates"

  before_save :remove_select_section_bad_data

  validates_presence_of :name

  def remove_select_section_bad_data
    if select_section.first == '' || select_section.first == 'Select section*'
      updated_select_section = select_section
      updated_select_section.shift
      self.select_section = updated_select_section
    end
  end

  def checkbox_options_for_select_section
    full_field_names = TableRetrieval.attributes(table_names)[:table_attributes].map do |key,values|
      values.map{|value|"#{key}.#{value}"}
    end.flatten
    fields = ["*"] + full_field_names
    fields.map do |attribute_name|
      [attribute_name, attribute_name, {checked: select_section.include?(attribute_name)}]
    end
  end

  def radio_options_for_group_by_section
    full_field_names = TableRetrieval.attributes(table_names)[:table_attributes].map do |key,values|
      values.map{|value|"#{key}.#{value}"}
    end.flatten
    full_field_names.map do |attribute_name|
      [attribute_name, attribute_name, {checked: group_by_section.include?(attribute_name)}]
    end
  end

  def radio_options_for_order_section
    full_field_names = TableRetrieval.attributes(table_names)[:table_attributes].map do |key,values|
      values.map{|value|"#{key}.#{value}"}
    end.flatten
    full_field_names.map do |attribute_name|
      [attribute_name, attribute_name, {checked: order_section.include?(attribute_name)}]
    end
  end

  def select_section_with_aggregates
    select_section
  end

  private
  def table_names
    tables = []
    tables << from_section
    if join_section
      join_section_tables = match_join_section_to_table_names
      tables << join_section_tables
    end
    tables.compact.uniq.join(",")
  end

  def match_join_section_to_table_names
    # join_section.split(/.* join (.*) on[^,]+/i, '\1')
    table_names = TableRetrieval.all_tables
    possible_table_names = join_section.split(" ")
    join_table_names = possible_table_names.select do |possible_table_name|
      table_names.include?(possible_table_name)
    end
    return join_table_names
  end
end
