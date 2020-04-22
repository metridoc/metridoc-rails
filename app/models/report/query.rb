require 'csv'
class Report::Query < ApplicationRecord
  serialize :select_section, Array
  serialize :order_section, Array
  self.table_name = "report_queries"
  before_save :remove_select_section_blank

  belongs_to :owner, class_name: "AdminUser"
  belongs_to :report_template, class_name: "Report::Template", optional: true

  before_validation :set_defaults
  after_create  :queue_process

  validates_presence_of :name, :from_section

  def process
    return unless self.status.blank? || self.status == 'pending'

    self.update_columns(last_run_at: Time.now, status: "in-progress", total_rows_to_process: nil, n_rows_processed: nil)
    ReportQueryMailer.with(report_query: self).started_notice.deliver_now

    sleep(5) # give a quick brake to make sure both emails go out even if it is a fast process

    self.update_columns(status: export ? "success" : "failed")
    ReportQueryMailer.with(report_query: self).finished_notice.deliver_now
  end

  def export
    sql_2 =         " FROM #{self.from_section}"
    sql_2 = sql_2 + " WHERE #{self.where_section} " if self.where_section.present?
    sql_2 = sql_2 + " GROUP BY #{self.group_by_section} " if self.group_by_section.present?
    sql_2 = sql_2 + " ORDER BY #{self.order_section.first} #{self.order_direction_section}" if self.order_section.present?

    sql = "SELECT COUNT(*) AS total_rows_to_process " + sql_2
    result = ActiveRecord::Base.connection.exec_query(sql)
    total_rows_to_process = result.rows.first[0]
    update_column(:total_rows_to_process, total_rows_to_process)

    sql = "SELECT #{self.select_section.blank? ? "*" : self.select_section.join(",")} " + sql_2
    result = ActiveRecord::Base.connection.exec_query(sql)

    self.output_file_name = "#{self.name.parameterize.underscore}_#{self.id}.csv"

    headers = result.columns

    n_rows_processed = 0
    CSV.open("tmp/" + self.output_file_name, 'w', write_headers: true, headers: headers) do |csv|
      result.rows.each do |row|
        n_rows_processed = n_rows_processed + 1
        update_column(:n_rows_processed, n_rows_processed) if n_rows_processed == 1 || (n_rows_processed % 10 == 0)
        csv << row
        sleep(1) if (n_rows_processed % 10 == 0) # TODO testing
      end
    end
    update_column(:n_rows_processed, n_rows_processed)

    self.last_error_message = nil
    save!

    return true

    rescue => ex
      puts "Error while exporting records => #{ex.message}"
      self.output_file_name = nil
      self.last_error_message = ex.message
      save!
      return false
  end

  def re_process
    update_columns(last_run_at: nil, status: nil, output_file_name: nil, total_rows_to_process: nil, n_rows_processed: nil)
    queue_process
  end

  def progress_text
    n_rows_processed && n_rows_processed > 0 ? "#{n_rows_processed} of #{total_rows_to_process} rows exported" : "-"
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

  def radio_options_for_order_section
    full_field_names = TableRetrieval.attributes(table_names)[:table_attributes].map do |key,values|
      values.map{|value|"#{key}.#{value}"}
    end.flatten
    full_field_names.map do |attribute_name|
      [attribute_name, attribute_name, {checked: order_section.include?(attribute_name)}]
    end
  end

  private
  def set_defaults
    self.status = 'pending' if self.status.blank?

    if new_record? && self.report_template_id.present? && self.select_section.blank? && self.from_section.blank? && self.where_section.blank? && self.group_by_section.blank? && self.order_section.blank?
      self.select_section = self.report_template.select_section
      self.from_section = self.report_template.from_section
      self.where_section = self.report_template.where_section
      self.group_by_section = self.report_template.group_by_section
      self.order_section = self.report_template.order_section
    end

  end

  def queue_process
    self.delay.process if self.status.blank? || self.status == 'pending'
  end

  def remove_select_section_blank
    if select_section.first == ''
      updated_select_section = select_section
      updated_select_section.shift
      self.select_section = updated_select_section
    end
  end

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
