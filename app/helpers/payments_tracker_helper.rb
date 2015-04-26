module PaymentsTrackerHelper

  def sync_payment_data
    response_data = Hash.new
    mechanize = Mechanize.new

    # create a new sync object
    # get all the players from the scrapper
    players = log_in_get_player_info(mechanize)
    players_by_payments = sort_players(players)

    sync = TeamsnapPaymentsSync.new(
      :total_players => players.length,
      :total_paid_players => players_by_payments[:paid].length,
      :total_unpaid_players => players_by_payments[:unpaid].length,
      :total_players_updated => players_by_payments[:new_paid].length,
      :is_success => true
    )
    sync.save
    
    response_data[:sync] = sync
    #response_data[:sync_created_string] = sync.created_at.strftime('%B %e at %l:%M %p')
    response_data[:players_updated_count] = players_by_payments[:new_paid].length
    #response_data[:scan_row_html] = render_to_string(:template => "payments_tracker/_payments_row.haml", :locals => {:scan => sync})
    response_data[:new_paid_players] = players_by_payments[:new_paid]
    
    # send the email if there are new payments
    if response_data[:new_paid_players].length > 0
      puts 'Sending New Payment Emails'
      PaymentMailer.new_payments(response_data[:new_paid_players]).deliver
    end
    # update the players on teamsnap
    log_in_update_players_on_teamsnap(players_by_payments[:new_paid])
  end

  #
  # Loads the player teamsnap page and updates all of the given players by visiting the url
  #
  def log_in_update_players_on_teamsnap(players)
    @agent = log_in_to_teamsnap_sync

    players.each do |player|
      set_paid_teamsnap_player(@agent, player['player_url'])
    end
  end

  #
  # Log into teamsnap and update the player infromation
  #
  def log_in_get_player_info(mechanize)
    latest_account = TeamsnapScanAccount.order('created_at DESC').first
    @players = Array.new
    league_roster_url = 'https://go.teamsnap.com/16139/league_roster/list'
    if !latest_account.nil?
      login_results = login_to_teamsnap(mechanize, latest_account)

      if is_login_successful?(login_results)
        players = Array.new
        league_page = login_results.link_with(:text => "Big Apple Softball League ").click
        @players = fetch_league_roster(league_page)
      else
        puts "Web Scrapper has failed"
      end
    end
    @players
  end

  #
  # Sort players by paid, unpaid and new payments 
  #
  def sort_players(players)
    players_by_payments = Hash.new
    players_by_payments[:paid] = Array.new
    players_by_payments[:unpaid] = Array.new
    players_by_payments[:new_paid] = Array.new
    players_update_count = 0
    # get all paid players
    players.each do |player|
      if player['has_paid?']
        players_by_payments[:paid].push(player)

        teamsnap_payment = TeamsnapPayment.new(
            :teamsnap_player_id => player['teamsnap_id'],
            :teamsnap_player_name => player['name'],
            :teamsnap_player_email => player['email']
          )
        # make sure we can save the payment
        if teamsnap_payment.valid?
          teamsnap_payment.save
          players_update_count += 1
          players_by_payments[:new_paid].push(player)
        end
        # for each paid player check and add them to the teamsnap_payments page
      else
        players_by_payments[:unpaid].push(player)
      end
    end
    players_by_payments
  end

  #
  # gets the latest account and logs into teamsnap
  # due to some weird sesisons issue we have to go the the league page
  # before redirecting
  #
  def log_in_to_teamsnap_sync
    latest_account = TeamsnapScanAccount.order('created_at DESC').first
    result = Hash.new
    @agent = Mechanize.new
    if !latest_account.nil?
      login_url = "https://go.teamsnap.com/login/signin"
      page = @agent.get(login_url)
      login_results = Hash.new
      login_form = page.forms.first
      login_form.field_with(:name => "login").value = latest_account.username
      login_form.field_with(:name => "password").value = latest_account.password
      login_results = @agent.submit login_form
      league_page = login_results.link_with(:text => "Big Apple Softball League ").click
      if is_login_successful?(login_results)
        @agent
      else
        puts "Web Scrapper has failed to Log in"
        @agent
      end
    else
      @agent
    end
    @agent
  end

  #
  # Set a player as paid
  #
  def set_paid_teamsnap_player(agent, player_url)
    player_paid_text = "Paid"

    player_page = agent.get(player_url)

    player_form = player_page.forms.first
    jersey_form_field = player_form.field_with(:name => "roster[number]")
    current_jersey_value = jersey_form_field.value

    if !current_jersey_value.include?(player_paid_text)
      jersey_form_field.value = "#{current_jersey_value} #{player_paid_text}"
    end

    player_form.checkbox_with(:name => "custom[143981]").check # set the Player as register
    player_form.submit
  end
end
