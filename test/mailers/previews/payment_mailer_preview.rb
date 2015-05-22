# Preview all emails at http://localhost:3000/rails/mailers/payment_mailer
class PaymentMailerPreview < ActionMailer::Preview
  include TeamsnapHelper

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

    mechanize = Mechanize.new
    account = TeamsnapScanAccount.order('created_at DESC').first
    loginHash = log_in_to_teamsnap(account.username,account.password, false)
    if (loginHash[:teamsnapToken])
        @div_data = get_division_team_data(targeted_division_id, loginHash[:teamsnapToken])
            # for each division go through the list of teams and get their roster
            @div_name = target_div_name
            #ap teams
            #
            # create a new test mailer
            PaymentMailer.payments_roster(@div_data, @div_name, 'paigepon@gmail.com', 'paigepon@gmail.com')
            # get all the players for a given division
    end
  end
end
