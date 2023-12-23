class Log::JobExecution < Log::Base

  # Check if the source name is like *name*
  scope :of_source, -> (source_name) {
    where("source_name ILIKE ? ",  "%#{source_name}%")
  }

  # Find the parent source.
  scope :parent_source, -> (source_name, sources) {
    # Return the basic result
    unless source_name == "other"
      return self.of_source(source_name)
    end
    # If source_name is "other"
    # Return a linked series removing the named sources
    clause = self.where(nil)
    for source in sources do
      next if source == "other"
      clause = clause.where("source_name NOT ILIKE ? ",  "%#{source}%")
    end
    return clause
  }

  has_many :job_execution_steps, dependent: :destroy

  before_validation :set_defaults
  #
  # def self.parent_source(source_name, sources) {
  #   clause = nil
  #   if source_name == "other"
  #     for source in sources:
  #       clause.not_of_source(source)
  #     end
  #     return clause
  #   else
  #     return clause.of_source(source)
  #   end
  # }

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
