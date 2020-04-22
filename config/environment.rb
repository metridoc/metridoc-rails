# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => ENV['MAILER_USR'],
  :password => ENV['MAILER_PWD'],
  :domain => ENV['MAILER_DOMAIN'],
  :address => ENV['MAILER_HOST'],
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
