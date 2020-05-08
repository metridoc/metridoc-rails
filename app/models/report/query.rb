require 'csv'
class Report::Query < ApplicationRecord
  serialize :select_section, Array
  serialize :group_by_section, Array
  attr_accessor :select_section_with_aggregates
  attr_accessor :raw_join_clauses
  attr_reader :join_section
  self.table_name = "report_queries"

  before_save :remove_select_section_bad_data
  before_save :remove_group_by_section_bad_data

  belongs_to :owner, class_name: "AdminUser"
  belongs_to :report_template, class_name: "Report::Template", optional: true

  before_validation :set_defaults
  after_create  :queue_process

  validates_presence_of :name, uniqueness: true

  has_many :report_query_join_clauses, foreign_key: "report_query_id", class_name: "Report::QueryJoinClause", dependent: :destroy, inverse_of: :report_query
  accepts_nested_attributes_for :report_query_join_clauses, allow_destroy: true, reject_if: proc {|attributes| attributes['keyword'].blank? || attributes['table'].blank? || attributes['on_keys'].blank? }
  alias join_clauses report_query_join_clauses

  RECORDS_PER_PAGE = 10

  def process
    return unless self.status.blank? || self.status == 'pending'

    self.update_columns(last_run_at: Time.now, status: "in-progress", total_rows_to_process: nil, n_rows_processed: nil)
    ReportQueryMailer.with(report_query: self).started_notice.deliver_now

    sleep(5) # give a quick brake to make sure both emails go out even if it is a fast process

    export
    ReportQueryMailer.with(report_query: self).finished_notice.deliver_now
  end

  def export
    sql_2 =           " FROM #{self.from_section}"
    sql_2 =   sql_2 + " #{join_section}" if self.join_section.present?
    sql_2 =   sql_2 + " WHERE #{self.where_section} " if self.where_section.present?
    sql_2 =   sql_2 + " GROUP BY #{self.group_by_section.join(",")} " if self.group_by_section.present?
    if self.order_section.present? && self.order_direction_section.present?
      sql_2 = sql_2 + " ORDER BY #{self.order_section} #{self.order_direction_section} "
    elsif self.order_section.present?
      sql_2 = sql_2 + " ORDER BY #{self.order_section} "
    end

    sql = "SELECT COUNT(*) AS total_rows_to_process " + sql_2
    result = ActiveRecord::Base.connection.exec_query(sql)
    total_rows_to_process = result.rows.first[0]
    update_columns(n_rows_processed: 0, total_rows_to_process: total_rows_to_process)

    sql = "SELECT #{self.select_section.join(",")} " + sql_2 + " LIMIT 1 "
    result = ActiveRecord::Base.connection.exec_query(sql)

    self.output_file_name = "#{self.name.parameterize.underscore}_#{self.id}.csv"

    headers = result.columns

    n_rows_processed = 0
    CSV.open("tmp/" + self.output_file_name, 'w', write_headers: true, headers: headers) do |csv|
      offset = 0
      while result.rows.size > 0 do
        sql = "SELECT #{self.select_section.join(",")} " + sql_2 + " OFFSET #{offset} LIMIT #{RECORDS_PER_PAGE} "
        result = ActiveRecord::Base.connection.exec_query(sql)
        result.rows.each do |row|
          n_rows_processed = n_rows_processed + 1
          update_column(:n_rows_processed, n_rows_processed) if n_rows_processed % 10 == 0
          csv << row
          sleep(1) if (n_rows_processed % 10 == 0) # TODO testing
          puts "self.status=[#{self.status}]"
          if Report::Query.find(self.id).status == 'cancelled'
            cancel
            return false
          end
        end
        offset = offset + RECORDS_PER_PAGE
      end
    end
    update_column(:n_rows_processed, n_rows_processed)

    self.last_error_message = nil
    self.status = "success"
    save!
    return true

    rescue => ex
      puts "Error while exporting records => #{ex.message}"
      self.output_file_name = nil
      self.last_error_message = ex.message
      self.status = "failed"
      save!
      return false
  end

  def cancel
    update_columns(status: 'cancelled', output_file_name: nil, total_rows_to_process: nil, n_rows_processed: nil)
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
    if full_field_names.blank?
      []
    else
      fields = ["*"] + full_field_names
      fields.map do |attribute_name|
        [attribute_name, attribute_name, {checked: select_section.include?(attribute_name)}]
      end
    end
  end

  def radio_options_for_group_by_section
    if group_by_section.any?
      full_field_names = TableRetrieval.attributes(table_names)[:table_attributes].map do |key,values|
        values.map{|value|"#{key}.#{value}"}
      end.flatten
      full_field_names.map do |attribute_name|
        [attribute_name, attribute_name, {checked: group_by_section.include?(attribute_name)}]
      end
    end
  end

  def radio_options_for_order_section
    if order_section.blank?
      []
    else
      full_field_names = TableRetrieval.attributes(table_names)[:table_attributes].map do |key,values|
        values.map{|value|"#{key}.#{value}"}
      end.flatten
      full_field_names.map do |attribute_name|
        [attribute_name, attribute_name, {checked: order_section.include?(attribute_name)}]
      end
    end
  end

  def select_section_with_aggregates
    select_section
  end

  def raw_join_clauses=(raw_join_clauses)
    @raw_join_clauses = raw_join_clauses
  end

  def join_section
    join_statement = ""
    join_clauses.each do |join_clause|
      join_statement += "#{join_clause.keyword} #{join_clause.table} ON #{join_clause.on_keys} "
    end
    join_statement.strip
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

  def remove_select_section_bad_data
    if select_section.first == '' || select_section.first == 'Select Section*'
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

  def table_names
    tables = []
    tables << from_section
    if join_clauses.any?
      join_section_tables = join_clauses.pluck(:table)
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
