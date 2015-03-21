class PaymentsTrackerController < ApplicationController
  require 'open-uri'

  #
  # Stores the teamsnap division ids by the name of the division (this is very sensitive since the user can edit these names)
  #
  def teamsnap_divs_by_id
    ids_by_div_name = Hash.new
    ids_by_div_name['1. Dima Division'] = 27394
    ids_by_div_name['2. Stonewall Division'] = 27395
    ids_by_div_name['3. Fitzpatrick Division'] = 27397
    ids_by_div_name['4. Rainbow Division'] = 27398
    ids_by_div_name['5. Sachs Division'] = 27400
    ids_by_div_name["1. Women's Competitive Division"] = 27403
    ids_by_div_name["2. Women's Recreational Division"] = 27404
    ids_by_div_name["Big Apple Softball League"] = 16139 
    ids_by_div_name
  end

  def index
  end

  def new_account
    @teamsnap_sync_account = TeamsnapScanAccount.new
    render 'payments_tracker/account/new'
  end

  def create_account
    @account = TeamsnapScanAccount.new(teamsnap_scan_account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to '/payments/tracker', notice: 'Scans Account was successfully created.' }
      else
        format.html { redirect_to 'payments_tracker#new_account', notice: 'Error Saving Account.' }
      end
    end

  end

  # home page for the page tracker
  def home
    mechanize = Mechanize.new
    @players = log_in_get_player_info(mechanize)
  end

  def admin
    @scans = TeamsnapPaymentsSync.order('created_at DESC').all
    @latest_sync = TeamsnapPaymentsSync.order('created_at DESC').first
  end

  #
  # Gets a list of paid players on unassigned teams
  #
  def unassigned
    mechanize = Mechanize.new
    players = log_in_get_player_info(mechanize)
    ids_by_div_name = teamsnap_divs_by_id
    @unassigned_player = Array.new
    @league_id = ids_by_div_name["Big Apple Softball League"]
    players_by_payments = sort_players(players)
    players_by_payments[:paid].each do |player|
      if player['division_id'] == @league_id
        @unassigned_player.push(player)
      end
    end
  end 

  def sync
    @response_data = Hash.new
    mechanize = Mechanize.new

    # create a new sync object
    # get all the players from the scrapper
    players = log_in_get_player_info(mechanize)
    players_by_payments = sort_players(players)

    sync = TeamsnapPaymentsSync.new(
      :total_players => players.length,
      :total_paid_players => players_by_payments[:paid].length,
      :total_unpaid_players => players_by_payments[:unpaid].length,
      :total_players_updated => players_update_count,
      :is_success => true
    )

    sync.save
    @response_data[:sync] = sync
    @response_data[:sync_created_string] = sync.created_at.strftime('%B %e at %l:%M %p')
    @response_data[:players_updated_count] = players_update_count
    @response_data[:scan_row_html] = render_to_string(:template => "payments_tracker/_payments_row.haml", :locals => {:scan => sync})
    @response_data[:new_paid_players] = players_by_payments[:new_paid]

    log_in_update_players_on_teamsnap(players_by_payments[:new_paid])

    respond_to do |format|
      format.json { render :json=> @response_data}
      format.html { render :layout => false }
    end
  end

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
  # Loads the player teamsnap page and updates all of the given players by visiting the url
  #
  def log_in_update_players_on_teamsnap(players)
    @agent = log_in_to_teamsnap

    players.each do |player|
      set_paid_teamsnap_player(@agent, player['player_url'])
    end

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

  def list
    @payments = TeamsnapPayment.all
  end


  private

    #
    # gets the latest account and logs into teamsnap
    # due to some weird sesisons issue we have to go the the league page
    # before redirecting
    #
    def log_in_to_teamsnap
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
    # Caches the league roster so we don't have to make too many API quesi
    #
    def fetch_league_roster(league_page)
      Rails.cache.fetch("teamsnap_league_rosterv4", :expires_in => 60.minutes) do
        league_roster(league_page)
      end
    end

    #
    # Iterates through all the roster pages and
    # returns an array ofr all the leauges' roster
    #
    def league_roster(league_page)
      players = Array.new
      roster_page = league_page.link_with(:text => "League_roster").click
      players.concat(get_roster_page_player_info(roster_page))

      next_link = roster_page.link_with(:class => 'next_page')

      # while there is a next button, iterate through all the of the players
      # populate the date
      while(!next_link.nil?) do
        roster_page_next = next_link.click
        players.concat(get_roster_page_player_info(roster_page_next))
        next_link = roster_page_next.link_with(:class => 'next_page')
      end
      players
    end

    #
    # Iterates through a roster table to get the player info for that page
    #
    def get_roster_page_player_info(roster_page)
      ids_by_div_name = teamsnap_divs_by_id

      players = Array.new
      paid_string = 'PAID IN FULL'
      roster_table_rows = roster_page.parser.css('#players_table > tbody > tr')
      roster_table_rows.each do |roster_table_row|
        player = Hash.new
        roster_table_columns = roster_table_row.css('td')
        # set player info
        info_column = roster_table_columns[2]
        player_link = info_column.css('strong a')
        player['teamsnap_id'] = player_link.attribute('href').to_s.split('/')[4].to_i
        player['name'] = player_link.text.strip
        player['has_paid?'] = info_column.text.include?(paid_string)

        # set player email
        email_column = roster_table_columns[3]
        player['email'] = email_column.css('a').text.strip

        #set player teaminfo
        team_column = roster_table_columns[4]
        player['team'] = team_column.css('a').text.strip
        player['team_division'] = team_column.text.strip[/\(.*?\)/].tr(')(','').strip
        player['division_id'] = ids_by_div_name[player['team_division']]
        player['player_url'] = "https://go.teamsnap.com/#{player['division_id']}/league_roster/edit/#{player['teamsnap_id']}"
        players.push(player)
      end
      players
    end

    #
    # Logs into teamsnap and returns the next page if successful
    #
    def login_to_teamsnap(mechanize, latest_account)
      login_url = "https://go.teamsnap.com/login/signin"

      page = mechanize.get(login_url)
      login_results = Hash.new

      login_form = page.forms.first
      login_form.field_with(:name => "login").value = latest_account.username
      login_form.field_with(:name => "password").value = latest_account.password
      login_results = mechanize.submit login_form
      login_results
    end

    #
    # checks to see if you've made it to the dashboardp age
    #
    def is_login_successful?(page)
      (page.uri.to_s== "https://go.teamsnap.com/team/dashboard")
    end

  private
    def teamsnap_scan_account_params
      params.require(:teamsnap_scan_account).permit(:username, :password, :is_active)
    end

end