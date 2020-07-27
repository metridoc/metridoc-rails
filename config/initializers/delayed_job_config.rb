Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.queue_attributes = {
  default: { priority: -10 },
  large:   { priority: 10  }
}
Delayed::Worker.max_run_time = 24.hours
Delayed::Worker.destroy_failed_jobs = false
