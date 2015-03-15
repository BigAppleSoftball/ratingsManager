class PaymentsTrackerController < ApplicationController
  require 'open-uri'

  # home page for the page tracker
  def home
    mechanize = Mechanize.new
    @players = log_in_get_player_info(mechanize)
  end

  def admin
    @scans = TeamsnapPaymentsSync.order('created_at DESC').all
    @latest_sync = TeamsnapPaymentsSync.order('created_at DESC').first
  end

  def run_sync
    response = Hash.new
    mechanize = Mechanize.new
    # create a new sync object

    # get all the players from the scrapper
    players = log_in_get_player_info(mechanize)

    players_by_payments = Hash.new
    players_by_payments[:paid] = Array.new
    players_by_payments[:unpaid] = Array.new
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
        end
        # for each paid player check and add them to the teamsnap_payments page
      else
        players_by_payments[:unpaid].push(player)
      end
    end

    sync = TeamsnapPaymentsSync.new(
      :total_players => players.length,
      :total_paid_players => players_by_payments[:paid].length,
      :total_unpaid_players => players_by_payments[:unpaid].length,
      :total_players_updated => players_update_count,
      :is_success => true
    )
    
    sync.save
    response[:sync] = sync
    response[:sync_created_string] = sync.created_at.strftime('%B %e at %l:%M %p')
    response[:players_updated_count] = players_update_count
    response[:scan_row_html] = render_to_string(:template => "payments_tracker/_payments_row.haml", :locals => {:scan => sync})
    respond_to do |format|
      format.json { render :json=> response}
    end
  end

  def update_teamsnap_player
    update_player
  end

  def list
    @payments = TeamsnapPayment.all
  end


  private

    def log_in_get_player_info(mechanize)
      @players = Array.new
      league_roster_url = 'https://go.teamsnap.com/16139/league_roster/list'

      login_results = login_to_teamsnap(mechanize)

      if is_login_successful?(login_results)
        players = Array.new
        league_page = login_results.link_with(:text => "Big Apple Softball League ").click
        @players = fetch_league_roster(league_page)
      else
        puts "Web Scrapper has failed"
      end
      @players
    end

    #
    # Caches the league roster so we don't have to make too many API quesi
    #
    def fetch_league_roster(league_page)
      Rails.cache.fetch("teamsnap_league_roster", :expires_in => 60.minutes) do
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
        player['team_division'] = team_column.text.strip[/\(.*?\)/].tr(')(','')

        players.push(player)
      end
      players
    end

    #
    # Logs into teamsnap and returns the next page if successful
    #
    def login_to_teamsnap(mechanize)
      login_url = "https://go.teamsnap.com/login/signin"
      
      page = mechanize.get(login_url)

      login_form = page.forms.first
      login_form.field_with(:name => "login").value = "paigepon@gmail.com"
      login_form.field_with(:name => "password").value = "paige123"
      login_results = mechanize.submit login_form

      login_results
    end

    #
    # checks to see if you've made it to the dashboardp age
    #
    def is_login_successful?(page)
      (page.uri.to_s== "https://go.teamsnap.com/team/dashboard")
    end

end