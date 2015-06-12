class PaymentMailer < ApplicationMailer

  default from: 'notifications@example.com'

  #
  # Send emails regarding new payments recieved
  #
  def new_payments(payments)
    mailInfo = getEmailDefaults("#{payments.length} New Payment(s)", 'webteam@bigapplesoftball.com')
    @payments = payments
    mail(mailInfo)
  end

  #
  # Sends email containing all the valid roster of players
  #
  def payments_roster(div_roster, div_name, toEmail, ccEmail)
    @div_roster = div_roster
    @div_name = div_name
    mailInfo = getEmailDefaults("Eligible Rosters for #{@div_name}", toEmail, ccEmail)
    mail(mailInfo)
  end

  #
  # If We're testing localled, note that in the subject and only send it to me
  #
  def getEmailDefaults(subject, toEmail, ccEmail = nil)
    if Rails.env.eql? 'development'
      subject = "[BASL-DEV] #{subject}"
      toEmail = 'paigepon@gmail.com'
      ccEmail = toEmail
    else
      subject = "[BASL] #{subject}"
    end
    mailInfo = {
      :to => toEmail,
      :subject => subject,
      :cc => ccEmail
    }
    mailInfo
  end
end