# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => ENV['MAILER_USR'],
  :password => ENV['MAILER_PWD'],
  :from => ENV['MAILER_DEFAULT_FROM'],
  :domain => ENV['MAILER_DOMAIN'],
  :address => ENV['MAILER_HOST'],
  :port => 25,
  :authentication => :plain,
  :enable_starttls_auto => true
}
