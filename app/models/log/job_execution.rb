module Log

  class JobExecution < ActiveRecord::Base
    self.table_name_prefix = 'log_'

    scope :of_source, -> (source_name) { where(source_name: source_name) }

    has_many :job_execution_steps

    before_validation :set_defaults

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
      global_yml.map{|key, val| global_yml[key] = ( key.match(/password/i) ? "[FILTERED]" : val) }
    end

  end

end
