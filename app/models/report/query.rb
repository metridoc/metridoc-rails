require 'csv'
class Report::Query < ApplicationRecord
  self.table_name = "report_queries"

  belongs_to :owner, class_name: "AdminUser"
  belongs_to :report_template, class_name: "Report::Template"

  before_validation :set_defaults
  after_create  :queue_process

  validates_presence_of :name, :select_section, :from_section

  def process
    return unless self.status.blank? || self.status == 'pending'

    self.update_columns(last_run_at: Time.now, status: "in-progress")
    ReportQueryMailer.with(report_query: self).started_notice.deliver_now

    sleep(5) # give a quick brake to make sure both emails go out even if it is a fast process

    self.update_columns(status: export ? "success" : "failed")
    ReportQueryMailer.with(report_query: self).finished_notice.deliver_now
  end

  def export
    sql = "SELECT #{self.select_section} FROM #{self.from_section} WHERE #{self.where_section}"
    sql = sql + " GROUP BY #{self.group_by_section} " if self.group_by_section.present?
    sql = sql + " ORDER BY #{self.order_section} " if self.order_section.present?
    result = ActiveRecord::Base.connection.exec_query(sql)

    self.output_file_name = "#{self.name.parameterize.underscore}_#{self.id}.csv"

    headers = result.columns

    CSV.open("tmp/" + self.output_file_name, 'w', write_headers: true, headers: headers) do |csv|
      result.rows.each do |row|
        csv << row
      end
    end

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
    self.last_run_at = nil
    self.status = nil
    self.output_file_name = nil
    save!
    process
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
  

end
