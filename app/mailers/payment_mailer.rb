class PaymentMailer < ApplicationMailer

  default from: 'notifications@example.com'

  def new_payments(payments)
    @payments = payments
    mail(from: 'automated@bigapplesoftball.com', to: 'webteam@bigapplesoftball.com', subject: "[BASL Manager] #{payments.length} New Payment(s)")
  end

  #
  # Sends email containing all the valid roster of players
  #
  def payments_roster(div_roster, div_name)
    @div_roster = div_roster
    @div_name = div_name
    mail(from: 'automated@bigapplesoftball.com', to: 'Paigepon@gmail.com', subject: "Here's your Roster of Valid players")
  end
end