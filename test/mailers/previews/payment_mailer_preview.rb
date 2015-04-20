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
    division_ids = teamsnap_divs_by_id
    target_div_name = '4. Rainbow Division'
    targeted_division_id = teamsnap_divs_by_id[target_div_name]
    ap "TESTING THIS URL"
    ap targeted_division_id
    mechanize = Mechanize.new
    # get all teams
    @div_data = get_division_team_data(targeted_division_id)
    #players = log_in_get_player_info(mechanize)
    # for each division go through the list of teams and get their roster
    ap "DIVISION DATA IS RIGHT HERE ---------------"
    ap @div_data
    @div_name = target_div_name
    #ap teams
    #
    # create a new test mailer
    PaymentMailer.payments_roster(@div_data, @div_name)
    # get all the players for a given division
  end

end
