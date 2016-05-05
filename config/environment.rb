# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# sending emails on the localhost
# I recommend using this line to show error
ActionMailer::Base.raise_delivery_errors = true



ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.gmail.com',
  :domain         => 'mail.google.com',
  :port           => 587,
  :user_name      => 'mail@bigapplesoftball.com',
  :password       => 'mailer12345',
  :authentication => :plain,
  :enable_starttls_auto => true
}