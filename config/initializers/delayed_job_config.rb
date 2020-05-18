Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.queue_attributes = {
  default: { priority: -10 },
  large:   { priority: 10  }
}