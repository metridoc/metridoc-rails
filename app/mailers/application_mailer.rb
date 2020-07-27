class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILER_DEFAULT_FROM']
  layout 'mailer'
end
