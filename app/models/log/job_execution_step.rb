class Log::JobExecutionStep < Log::Base
  belongs_to :job_execution

  before_validation :set_defaults

  def title
    I18n.t("phrases.log_job_execution.title", execution_id: self.job_execution.id, step_name: self.step_name)
  end

  def set_status!(status)
    self.status = status
    save!
  end

  def log_line(line)
    self.log_text = (self.log_text.present? ? self.log_text + "\n" : "") + line
    save!
  end

  private
  def set_defaults
    self.status_set_at = Time.now if status_changed?
    step_yml.map{|key, val| step_yml[key] = ( key.match(/password/i) ? "[FILTERED]" : val) }
  end
end
