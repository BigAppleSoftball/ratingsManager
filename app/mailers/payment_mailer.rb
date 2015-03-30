class PaymentMailer < ApplicationMailer

  default from: 'notifications@example.com'
 
  def new_payments(payments)
    @payments = payments
    mail(from: 'automated@bigapplesoftball.com', to: 'Paigepon@gmail.com', subject: "[BASL Manager] #{payments.length} New Payment(s)!")
  end
end