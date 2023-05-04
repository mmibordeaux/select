# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  api_key: ENV['MAILGUN_API_KEY'],
  user_name: ENV['MAILGUN_SMTP_LOGIN'],
  password: ENV['MAILGUN_SMTP_PASSWORD'],
  domain: ENV['MAILGUN_DOMAIN'],
  address: ENV['MAILGUN_SMTP_SERVER'],
  port: ENV['MAILGUN_SMTP_PORT'],
  authentication: :plain,
  enable_starttls_auto: true
}
