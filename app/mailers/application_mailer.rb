class ApplicationMailer < ActionMailer::Base
  default from: "basl-manager@basl-manager.herokuapp.com"
  layout 'mailer'
end
