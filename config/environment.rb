# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  port:           ENV['SENDINBLUE_PORT'],
  address:        ENV['SENDINBLUE_SMTP_SERVER'],
  user_name:      ENV['SENDINBLUE_SMTP_LOGIN'],
  password:       ENV['SENDINBLUE_SMTP_PASSWORD'],
  authentication: :plain
}

