module TeamsnapHelper
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
    ids_by_div_name["1. Mousseau Division"] = 27403
    ids_by_div_name["2. Green-Batten Division"] = 27404
    ids_by_div_name["Big Apple Softball League"] = 16139
    ids_by_div_name
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
  # Get all teams from the teamsnamp api and cache them
  #
  def get_all_teams
    Rails.cache.fetch("all_teams", :expires_in => 60.minutes) do
      get_all_teams_api
    end
  end

  #
  # Get all teams api
  #
  def get_all_teams_api
    teamsURL = 'https://api.teamsnap.com/v2/teams'
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => cookies[:teamsnap_token]}
    ap "CONNECT"
    ap conn
    response = conn.get teamsURL
    preprocess_team_data(JSON.parse(response.body))
  end

    #
  # Log user into the teamsnap api (return status)
  #
  def log_in_to_teamsnap(username, password)
    loginURL = 'https://api.teamsnap.com/v2/authentication/login/'
    conn = connect
    loginHash = Hash.new
    if cookies[:teamsnap_token].nil?
      conn.params  = {'user' => username, 'password' => password}
      conn.headers = {'Content-Type'=> 'application/json'}
      response = conn.post loginURL
      loginHash[:status] = response.headers['status']
      loginHash[:message] = response.headers['x-rack-cache']
      teamsnapToken = response.headers['x-teamsnap-token']
      if teamsnapToken.nil?
        loginHash[:failed] = true
      else
        loginHash[:success] = true
        cookies[:teamsnap_token] = teamsnapToken
        set_admin(username)
      end
    end
    # TODO (check if user has admin permissions on app)
    loginHash
  end

  #
  # Connect to the teamsnap api
  #
  def connect
    url = 'https://api.teamsnap.com/'
    conn = Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  #
  #
  # sort Teams by division
  #
  def preprocess_team_data(teamsData)
    divisionsList = Array.new
    teamsByDivision = Hash.new
    teamsData.each do |teamData|
      team = teamData['team']
      ap team['division_id']
      teamDivision = team['division_id']
      # check to see if division is in the list, if not add it
      if (!divisionsList.include?(teamDivision))
        divisionsList.push(teamDivision)
        teamsByDivision[teamDivision] = Array.new
      end
        teamsByDivision[teamDivision].push(team)
    end
    teamsByDivision
  end

  def get_roster(teamId, rosterId)
    rosterURL = "https://api.teamsnap.com/v2/teams/#{teamId}/as_roster/#{rosterId}/rosters"
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => cookies[:teamsnap_token]}
    response = conn.get rosterURL
    JSON.parse(response.body)
  end

  def get_roster_player(teamId, rosterId, playerId)
    rosterPlayerURL = "https://api.teamsnap.com/v2/teams/#{teamId}/as_roster/#{rosterId}/rosters/#{playerId}"
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => cookies[:teamsnap_token]}
    response = conn.get rosterPlayerURL
    JSON.parse(response.body)
  end

  def get_team(teamId)
    teamsURL = "https://api.teamsnap.com/v2/teams/#{teamId}"
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => cookies[:teamsnap_token]}
    response = conn.get teamsURL
    JSON.parse(response.body)
  end


  def get_roster(teamId, rosterId)
    rosterURL = "https://api.teamsnap.com/v2/teams/#{teamId}/as_roster/#{rosterId}/rosters"
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => cookies[:teamsnap_token]}
    response = conn.get rosterURL
    JSON.parse(response.body)
  end

  #
  # TODO (make the cache support division ids)
  #
  def get_division_team_data(division_id)
    #Rails.cache.fetch("division_data2-#{division_id}", :expires_in => 60.minutes) do
      get_division_team_data_api(division_id)
    #end
  end

    def get_customIds(ratingSection = nil)
    customHash = Hash.new
    customHash['throwing'] = Hash.new
    customHash['throwing'][1] = 81159
    customHash['throwing'][2] = 81165
    customHash['throwing'][3] = 81166
    customHash['throwing'][4] = 81169
    customHash['throwing'][5] = 81170
    customHash['fielding'] = Hash.new
    customHash['fielding'][6] = 81173
    customHash['fielding'][7] = 81175
    customHash['fielding'][8] =  81176
    customHash['fielding'][9] = 81178
    customHash['fielding'][10] = 81181
    customHash['fielding'][11] = 81187
    customHash['fielding'][12] = 81190
    customHash['fielding'][13] = 81193
    customHash['fielding'][14] = 81196
    customHash['baserunning'] = Hash.new
    customHash['baserunning'][15] = 81198
    customHash['baserunning'][16] = 81199
    customHash['baserunning'][17] = 81201
    customHash['baserunning'][18] = 81204
    customHash['hitting'] = Hash.new
    customHash['hitting'][19] = 81207
    customHash['hitting'][20] = 81210
    customHash['hitting'][21] = 81212
    customHash['hitting'][22] = 81215
    customHash['hitting'][23] = 81218
    customHash['hitting'][24] = 81223
    customHash['hitting'][25] = 81224
    customHash['hitting'][26] = 81225
    customHash['hitting'][27] = 81226
    if (ratingSection.nil?)
      customHash
    else
      customHash[ratingSection]
    end
  end

  # TODO
  def get_division_team_data_api(division_id)
    division_data = Hash.new
    division_data[:all_teams] = get_all_teams
    
    division_data[:all_divisions] =  get_all_divisions
    division_teams= Array.new
    division_data[:all_divisions]['division']['divisions'].each do |league|
      #ap league
      league['divisions'].each do |division|
        # only crawl the information for the division we are looking for
        if (division['id'] == division_id)
          
          teamsData = division_data[:all_teams][division_id]
          teamsData.each do |team|
            division_team = Hash.new
            
            # get the team data for the team
            if team
              division_team[:team] = team
              roster = team['available_rosters'].first
              if roster
                team_roster = team['available_rosters'].first
                roster_id = roster['id']
                roster = get_roster(team['id'], roster_id)
                @roster = roster
                roster
                #rosterId = params[:rosterId]
                #team = get_team(params[:teamId])['team'])
                player = Hash.new
                player[:roster] = roster
                division_team[:player] = preprocess_player_data(roster)
              end

            end
            division_teams.push(division_team)
        end
        division_data[:teams_data]= division_teams
        end
      end
      division_data
    end
    division_data
  end


  # adds and compiles players rankings
  def preprocess_player_data(roster)
    playersHash = Hash.new
    playerPayments = TeamsnapPayment.all
    customThrowingIds = get_customIds('throwing').values
    customFieldingIds = get_customIds('fielding').values
    customRunningIds = get_customIds('baserunning').values
    customHittingIds = get_customIds('hitting').values

    @roster.each do |playerData|
      playerHash = Hash.new
      playerHash[:throwing] = Hash.new
      playerHash[:fielding] = Hash.new
      playerHash[:running] = Hash.new
      playerHash[:hitting] = Hash.new
      playerHash[:throwing][:rating] = 0
      playerHash[:throwing][:ratings] = Hash.new
      playerHash[:fielding][:rating] = 0
      playerHash[:fielding][:ratings] = Hash.new
      playerHash[:running][:rating] = 0
      playerHash[:running][:ratings] = Hash.new
      playerHash[:hitting][:rating] = 0
      playerHash[:hitting][:ratings] = Hash.new
      player = playerData["roster"]
      customData = player['league_custom_data']
      payment_listing = playerPayments.select {|player_payment| player_payment[:teamsnap_player_id] == player['id'] }
        playerHash[:has_paid] = payment_listing.length > 0
      customData.each do |customItem|
        if customThrowingIds.include?(customItem['custom_field_id'])
          playerHash[:throwing][:rating] += customItem['content'].to_i
          playerHash[:throwing][:ratings][customItem['custom_field_id'].to_i] = customItem['content'].to_i
        elsif customFieldingIds.include?(customItem['custom_field_id'])
          playerHash[:fielding][:rating] += customItem['content'].to_i
          playerHash[:fielding][:ratings][customItem['custom_field_id'].to_i] = customItem['content'].to_i
        elsif customRunningIds.include?(customItem['custom_field_id'])
          playerHash[:running][:rating] += customItem['content'].to_i
          playerHash[:running][:ratings][customItem['custom_field_id'].to_i] = customItem['content'].to_i
        elsif customHittingIds.include?(customItem['custom_field_id'])
          playerHash[:hitting][:rating] += customItem['content'].to_i
          playerHash[:hitting][:ratings][customItem['custom_field_id'].to_i] = customItem['content'].to_i
        end
      end
      playerHash[:fullRating] = playerHash[:hitting][:rating] + playerHash[:running][:rating] + playerHash[:fielding][:rating] + playerHash[:throwing][:rating]

      playerHash[:name] = "#{player['first']} #{player['last']}"
      playersHash["#{player['id']}"] = playerHash
    end
    playersHash
  end

  #
  # checks to see if you've made it to the dashboardp age
  #
  def is_login_successful?(page)
    (page.uri.to_s== "https://go.teamsnap.com/team/dashboard")
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

end