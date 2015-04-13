class PaymentMailer < ApplicationMailer

  default from: 'notifications@example.com'

  #
  # Send emails regarding new payments recieved
  #
  def new_payments(payments)
    @payments = payments
    mail(from: 'automated@bigapplesoftball.com', to: 'webteam@bigapplesoftball.com', subject: "[BASL Manager] #{payments.length} New Payment(s)")
  end

  #
  # Sends email containing all the valid roster of players
  #
  def payments_roster(div_roster, div_name, toEmail, ccEmail)
    @div_roster = div_roster
    @div_name = div_name
    mail(from: 'automated@bigapplesoftball.com', to: toEmail, cc: ccEmail, subject: "[BASL] Eligible Rosters for #{@div_name}")
  end
end