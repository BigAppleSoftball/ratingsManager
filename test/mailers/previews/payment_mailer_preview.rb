# Preview all emails at http://localhost:3000/rails/mailers/payment_mailer
class PaymentMailerPreview < ActionMailer::Preview
  def new_payments
    test_players = Array.new
    player = Hash.new
    player['teamsnap_id'] = 324234234
    player['name'] = "Test Player"
    player['email'] = "paigepon@gmail.com"
    player["player_url"] = "http://google.com"
    test_players.push(player)
    PaymentMailer.new_payments(test_players)
  end

  def payments_roster
    PaymentMailer.payments_roster
    
    # get all the players for a given division
  end

end
