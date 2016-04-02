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
  # Gets the teamsnap_token if token sent is null
  #
  def get_teamsnap_token(token = nil)
    if (token.nil?)
      if (cookies[:teamsnap_token].present?)
        cookies[:teamsnap_token]
      else
        latest_account = TeamsnapScanAccount.order('created_at DESC').first
        # log into teamsnap api
        token = log_in_to_teamsnap(latest_account.username, latest_account.password, true)
      end
    else
      token
    end
  end

  #
  # Get all teams from the teamsnamp api and cache them
  #
  def get_all_teams(token = nil)
    Rails.cache.fetch("all_teamsv6", :expires_in => 60.minutes) do
      get_all_teams_api(token)
    end
  end


  #
  # Get all teams api
  #
  def get_all_teams_api(token = nil)
    token = get_teamsnap_token(token)
    teamsURL = 'https://api.teamsnap.com/v2/teams'
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => get_teamsnap_token(token)}
    response = conn.get teamsURL
    preprocess_team_data(JSON.parse(response.body))
  end

  #
  # Get all the divisions from the teamsnap api and cache them
  #
  def get_all_divisions(token = nil)
    Rails.cache.fetch("all_divisions", :expires_in => 60.minutes) do
      get_divisions(token)
    end
  end

  #
  # convert teamsnap data to objects
  #
  def teamsnap_divisions_to_objects(divisions, teams)
    divisionObjList = Array.new
    playerPayments = TeamsnapPayment.all

    divisions['division']['divisions'].each do |division|
      isCoed = false
      isWomens = false
      division_name = division['name']
      if division_name.include?('Open')
        isCoed = true
      elsif division_name.include?('Women')
        isWomens = true
      end

      # all of the divisions inside the sub division (women's coed)
      division['divisions'].each do |subdivision|
        divisionObj = Hash.new
        divisionObj[:description] = subdivision['name']
        if isCoed
          divisionObj[:kind] = 0
        elsif isWomens
          divisionObj[:kind] = 1
        end
        divisionObj[:teamsnap_id] = subdivision['id'].to_i
        divisionObj[:teams] = Array.new
        # get division teams
        division_teams = teams[subdivision['id'].to_i]
        division_teams.each do |division_team|
          divisionTeam = Hash.new
          divisionTeam[:name] = division_team['team_name']
          divisionTeam[:teamsnap_id] = division_team['id'].to_i
          roster_id  = division_team['available_rosters'].first['id']
          divisionTeam[:roster_id] = roster_id
          divisionTeam[:roster] = Array.new

          # get teamsm roster
          roster = get_roster(divisionTeam[:teamsnap_id], divisionTeam[:roster_id])
          playerRating = preprocess_player_data(roster, playerPayments)

          roster.each do |playerData|
            team_player = Hash.new
            team_player[:roster] = Hash.new
            team_player[:profile] = Hash.new
            team_player[:rating] = Hash.new
            team_player[:profile][:emails] = Array.new
            player = playerData["roster"]
            playerCustomLeague = player['league_custom_data']
            team_player[:roster][:teamsnap_id] = player['id']
            team_player[:profile][:first_name] = player['first']
            team_player[:profile][:last_name] = player['last']
            team_player[:profile][:gender] = player['gender']
            playerCustomLeague.each do |customItem|
              if (customItem['custom_field_id'] == 126483)
                team_player[:profile][:shirt_size] = customItem['content']
              elsif (customItem['custom_field_id'] == 126470)
                 team_player[:profile][:gender] = customItem['content']
              elsif (customItem['custom_field_id'] == 126485)
                if customItem['content'].include?('Non-Player')
                  team_player[:roster][:is_non_player] = true
                end
              elsif (customItem['custom_field_id'] == 126473)
                if customItem['content'].include?('Yes')
                  team_player[:profile][:is_pickup_player] = true
                end
              elsif (customItem['custom_field_id'] == 126478)
                team_player[:profile][:emergency_contact_name] = customItem['content']
              elsif (customItem['custom_field_id'] == 126479)
                team_player[:profile][:emergency_contact_relationship] = customItem['content']
              elsif (customItem['custom_field_id'] == 126480)
                team_player[:profile][:emergency_contact_phone] = customItem['content']
              end
            end

            team_player[:profile][:dob] = player['birthdate']
            if player['roster_email_addresses']
              ap "Player Emails ----- #{player['last']}"

              ap player['roster_email_addresses']
              if (player['roster_email_addresses'].blank?)
                ap player
              else
                ap player
              end
              player['roster_email_addresses'].each do |email_address|
                team_player[:profile][:emails].push(email_address['email'])
              end
            else
              ap "-------NO PLAYER EMAILS--------"
              ap player
            end

            if player['is_manager']
              team_player[:roster][:is_manager] = true
            end
            if player['address']
              team_player[:profile][:address] = player['address']['address']
              team_player[:profile][:address2] = player['address']['address2']
              team_player[:profile][:city] = player['address']['city']
              team_player[:profile][:state] = player['address']['state']
              team_player[:profile][:zip] = player['address']['zip']
            end

            if player['roster_telephone_numbers'].first
              team_player[:profile][:phone_number] = player['roster_telephone_numbers'].first['phone_number']
            end
            playerNumber = player['number']
            # we've been adding "paid" to players on teamsnap,
            # we want to remove that now
            if playerNumber
              playerNumber.slice! 'Paid'
              playerNumber.slice! '-'
              playerNumber.strip
              if !playerNumber.empty?
                team_player[:roster][:jersey_number] = playerNumber.strip
              end
            end
            playerRatingInfo = playerRating[team_player[:roster][:teamsnap_id].to_s]
            if playerRatingInfo
              team_player[:rating]= teamsnap_ratings_to_object(playerRatingInfo)
              team_player[:rating][:teamsnap_id] = player['id']
            end
            divisionTeam[:roster].push(team_player)
          end
          divisionObj[:teams].push(divisionTeam)
        end
        divisionObjList.push(divisionObj)
      end
    end
    #ap divisionObjList
    divisionObjList
  end

  #
  # Converts the teamsnap player ratings to an object
  # that matches up with the database
  #
  def teamsnap_ratings_to_object(playerRating)
    teamsnapRatingIds = get_customIds
    rating = Hash.new
    # rating[:all] = playerRating
    playerRatingThrowing = playerRating[:throwing][:ratings]
    playerRatingFielding = playerRating[:fielding][:ratings]
    playerRatingRunning = playerRating[:running][:ratings]
    playerRatingHitting = playerRating[:hitting][:ratings]

    # throwing 1 - 5
    rating[:rating_1] = playerRatingThrowing[teamsnapRatingIds['throwing'][1]]
    rating[:rating_2] = playerRatingThrowing[teamsnapRatingIds['throwing'][2]]
    rating[:rating_3] =playerRatingThrowing[teamsnapRatingIds['throwing'][3]]
    rating[:rating_4] = playerRatingThrowing[teamsnapRatingIds['throwing'][4]]
    rating[:rating_5] = playerRatingThrowing[teamsnapRatingIds['throwing'][5]]
    # field 6 - 14
    rating[:rating_6] = playerRatingFielding[teamsnapRatingIds['fielding'][6]]
    rating[:rating_7] = playerRatingFielding[teamsnapRatingIds['fielding'][7]]
    rating[:rating_8] = playerRatingFielding[teamsnapRatingIds['fielding'][8]]
    rating[:rating_9] = playerRatingFielding[teamsnapRatingIds['fielding'][9]]
    rating[:rating_10] = playerRatingFielding[teamsnapRatingIds['fielding'][10]]
    rating[:rating_11] = playerRatingFielding[teamsnapRatingIds['fielding'][11]]
    rating[:rating_12] = playerRatingFielding[teamsnapRatingIds['fielding'][12]]
    rating[:rating_13] = playerRatingFielding[teamsnapRatingIds['fielding'][13]]
    rating[:rating_13] = playerRatingFielding[teamsnapRatingIds['fielding'][13]]
    rating[:rating_14] = playerRatingFielding[teamsnapRatingIds['fielding'][14]]
    # running 15 - 18
    rating[:rating_15] = playerRatingRunning[teamsnapRatingIds['baserunning'][15]]
    rating[:rating_16] = playerRatingRunning[teamsnapRatingIds['baserunning'][16]]
    rating[:rating_17] = playerRatingRunning[teamsnapRatingIds['baserunning'][17]]
    rating[:rating_18] = playerRatingRunning[teamsnapRatingIds['baserunning'][18]]
    # hitting 19 - 27
    rating[:rating_19] = playerRatingHitting[teamsnapRatingIds['hitting'][19]]
    rating[:rating_20] = playerRatingHitting[teamsnapRatingIds['hitting'][20]]
    rating[:rating_21] = playerRatingHitting[teamsnapRatingIds['hitting'][21]]
    rating[:rating_22] = playerRatingHitting[teamsnapRatingIds['hitting'][22]]
    rating[:rating_23] = playerRatingHitting[teamsnapRatingIds['hitting'][23]]
    rating[:rating_24] = playerRatingHitting[teamsnapRatingIds['hitting'][24]]
    rating[:rating_25] = playerRatingHitting[teamsnapRatingIds['hitting'][25]]
    rating[:rating_26] = playerRatingHitting[teamsnapRatingIds['hitting'][26]]
    rating[:rating_27] = playerRatingHitting[teamsnapRatingIds['hitting'][27]]
    rating
  end

  #
  # Run a sync through teamsnap data
  # and save the new data to the database
  #
  def run_import(season_id)
    @errors = Array.new
    # going to just assume the last active season is the current season for now
    season_id = season_id.to_i
    season = Season.where(:id => season_id)
    if season.nil?
      error = Hash.new
      error[:type] = 'Season'
      error[:errors] = "Season Not Found"
      @errors.push(error)
      ap 'No season found, cancelling import'
      return
    end
    divisions = teamsnap_divisions_to_objects(get_all_divisions, get_all_teams)
    divisions.each do |division|
      imported_division = run_import_division(division, season_id)
      if imported_division.blank?
        error = Hash.new
        error[:type] = 'Division'
        error[:errors] = "Division failed to import"
        @errors.push(error)
        ap "Division Failed to Import #{division}"
        return
      end
      division[:teams].each do |team|
        imported_team = run_import_team(team, imported_division.id)
        if imported_team.blank?
          error = Hash.new
          error[:type] = 'Team'
          error[:errors] = "Team failed to import"
          @errors.push(error)
          return
        end
        team[:roster].each do |player|
          player = run_import_player(player, imported_team.id)
        end
      end
    end
  end

  #
  # Check to see if the division exists, if not save it
  #
  def run_import_division(division, season_id)
    # see if the division exists
    import_division = Division.where(:teamsnap_id => division[:teamsnap_id]).first

    if import_division.nil?
      import_division = Division.new
    end
    import_division.description = division[:description]
    import_division.kind = division[:kind]
    import_division.teamsnap_id = division[:teamsnap_id]
    import_division.season_id = season_id
    if !import_division.valid?
      error = Hash.new
      error[:type] = "Division #{import_division[:teamsnap_id]}"
      error[:errors] = import_division.errors
      @errors.push(error)
      ap "______ DIVISION IS NOT VALID TO SAVE _____"
      return
    end
    import_division.save
    import_division
  end

  #
  # Check to see if the team exists, if not create it
  # Then update it and save the information
  #
  def run_import_team(team, division_id)
    # get the team if it exists in the database
    import_team = Team.where(:teamsnap_id => team[:teamsnap_id]).first
    if import_team.nil?
      import_team = Team.new
    end

    import_team.name = team[:name]
    import_team.teamsnap_id = team[:teamsnap_id]
    import_team.division_id = division_id
    if !import_team.valid?
      error = Hash.new
      error[:type] = "Team #{team[:name]}"
      error[:errors] = import_team.errors?
      @errors.push(error)
      ap "______ TEAM #{team[:name]} IS NOT VALID TO SAVE _____"
      return
    end
    import_team.save
    import_team
  end

  #
  # Import Player Profile, ratings and roster relation to database
  #
  def run_import_player(player, team_id)
    # run profile import
    imported_profile = run_import_profile(player[:profile])
    # run roster import
    imported_roster = run_import_roster(player[:roster], team_id, imported_profile.id)
    # run ratings import
    imported_ratings = run_import_ratings(player[:rating],imported_profile.id)
  end

  #
  # Import roster to the database
  #
  def run_import_roster(roster, team_id, profile_id)
    import_roster = Roster.where(:teamsnap_id => roster[:teamsnap_id]).first
    if import_roster.nil?
      import_roster = Roster.new
      import_roster.teamsnap_id = roster[:teamsnap_id]
    end

    import_roster.is_non_player = roster[:is_non_player]
    import_roster.is_manager = roster[:is_manager]
    import_roster.jersey_number = roster[:jersey_number]
    import_roster.team_id = team_id
    import_roster.profile_id = profile_id

    if !import_roster.valid?
      error = Hash.new
      error[:type] = " Roster #{roster[:teamsnap_id]} #{team_id} #{profile_id}"
      error[:errors] = import_roster.errors
      @errors.push(error)
      ap import_roster.errors
      return
    end
    import_roster.save
    import_roster
  end

  #
  # Import Player Rating to the database
  #
  def run_import_ratings(rating,profile_id)
    # See if the rating teamsnap import already exist
    import_rating = Rating.where(:teamsnap_id => rating[:teamsnap_id]).first
    if import_rating.nil?
      import_rating = Rating.new
      import_rating.teamsnap_id = rating[:teamsnap_id]
      import_rating.profile_id = profile_id
    end

    import_rating.rating_1 = rating[:rating_1]
    import_rating.rating_2 = rating[:rating_2]
    import_rating.rating_3 = rating[:rating_3]
    import_rating.rating_4 = rating[:rating_4]
    import_rating.rating_5 = rating[:rating_5]
    import_rating.rating_6 = rating[:rating_6]
    import_rating.rating_7 = rating[:rating_7]
    import_rating.rating_8 = rating[:rating_8]
    import_rating.rating_9 = rating[:rating_9]
    import_rating.rating_10 = rating[:rating_10]
    import_rating.rating_11 = rating[:rating_11]
    import_rating.rating_12 = rating[:rating_12]
    import_rating.rating_13 = rating[:rating_13]
    import_rating.rating_14 = rating[:rating_14]
    import_rating.rating_15 = rating[:rating_15]
    import_rating.rating_16 = rating[:rating_16]
    import_rating.rating_17 = rating[:rating_17]
    import_rating.rating_18 = rating[:rating_18]
    import_rating.rating_19 = rating[:rating_19]
    import_rating.rating_20 = rating[:rating_20]
    import_rating.rating_21 = rating[:rating_21]
    import_rating.rating_22 = rating[:rating_22]
    import_rating.rating_23 = rating[:rating_23]
    import_rating.rating_24 = rating[:rating_24]
    import_rating.rating_25 = rating[:rating_25]
    import_rating.rating_26 = rating[:rating_26]
    import_rating.rating_27 = rating[:rating_27]

    if !import_rating.valid?
      error = Hash.new
      error[:type] = "Rating-#{import_rating.teamsnap_id}"
      error[:errors] = import_rating.errors
      @errors.push(error)
      ap "______ rating #{import_rating.teamsnap_id} Could Not save_____"
      ap import_rating.errors
      return
    end

    import_rating.save
    import_rating
  end

  #
  # Import Profile to the database
  #
  def run_import_profile(profile)
    ap "importing #{profile}"
    # check to see if the player profile exists, otherwise import it
    import_profile = Hash.new
    profile[:emails].each do |player_email|
      import_profile = Profile.where("lower(email) = LOWER('#{player_email}')").first
      if !import_profile.nil?
        break
      end
    end
    if profile[:emails].blank?
      profile[:emails].push("#{profile[:first_name]}#{profile[:last_name]}@teamsnap.com")
    end
    # this player doesn't exist create a new profile
    # Set the profile as the first email from the list
    if import_profile.blank?
      import_profile = Profile.new
      import_profile.email = profile[:emails].first
    end


    # try to find a profile with at least one of the email addresses
    import_profile.first_name = profile[:first_name]
    import_profile.last_name = profile[:last_name]
    if import_profile.first_name.blank?
      import_profile.first_name = 'importedPlayer*'
    end

    if import_profile.last_name.blank?
      import_profile.last_name = 'importedPlayer*'
    end
    import_profile.gender = profile[:gender]
    import_profile.shirt_size = profile[:shirt_size]
    import_profile.is_pickup_player = profile[:is_pickup_player]
    import_profile.emergency_contact_name = profile[:emergency_contact_name]
    import_profile.emergency_contact_relationship = profile[:emergency_contact_relationship]
    import_profile.emergency_contact_phone = profile[:emergency_contact_phone]
    import_profile.dob = profile[:dob]
    import_profile.address = profile[:address]
    import_profile.address2 = profile[:address2]
    import_profile.city = profile[:city]
    import_profile.state = profile[:state]
    import_profile.zip = profile[:zip]
    random_string = (0...8).map { (65 + rand(26)).chr }.join
    import_profile.password = random_string

    if !import_profile.valid?
      error = Hash.new
      error[:type] = "profile #{import_profile.first_name} #{import_profile.last_name} #{import_profile.email}"
      error[:errors] = import_profile.errors
      @errors.push(error)
      ap "---------Couldn't save profile #{import_profile.first_name} #{import_profile.last_name} #{import_profile.email} ----------"
      ap import_profile.errors
    end
    import_profile.save
    import_profile
  end

  # TODO get rid of old teamsnap crap
  def get_divisions(token = nil)
    divisionsURL = "https://api.teamsnap.com/v2/divisions/16139"
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => get_teamsnap_token(token)}
    response = conn.get divisionsURL
    JSON.parse(response.body)
  end


  #todo get rid of old teamsnap crap
  def get_roster(teamId, rosterId, token = nil)
    Rails.cache.fetch("team_roster-#{teamId}-#{rosterId}", :expires_in => 60.minutes) do
      get_roster_api(teamId, rosterId, token)
    end
  end

  def get_roster_api(teamId, rosterId, token=nil)
    rosterURL = "https://api.teamsnap.com/v2/teams/#{teamId}/as_roster/#{rosterId}/rosters"
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => get_teamsnap_token(token)}
    response = conn.get rosterURL
    JSON.parse(response.body)
  end

  #
  # Log user into the teamsnap api (return status)
  #
  def log_in_to_teamsnap(username, password, use_cookies=true)
    loginURL = 'https://api.teamsnap.com/v2/authentication/login/'
    conn = connect
    loginHash = Hash.new
    teamsnapToken = nil
    conn.params  = {'user' => username, 'password' => password}
    conn.headers = {'Content-Type'=> 'application/json'}
    if use_cookies && cookies[:teamsnap_token].nil?
      response = conn.post loginURL
      loginHash[:status] = response.headers['status']
      loginHash[:message] = response.headers['x-rack-cache']
      teamsnapToken = response.headers['x-teamsnap-token']
      if teamsnapToken.nil?
        loginHash[:failed] = true
      else
        loginHash[:success] = true
        if use_cookies
          cookies[:teamsnap_token] = teamsnapToken
        else
          teamsnapToken # if we aren't using the cookies return it
        end
      end
      return teamsnapToken
    else
      response = conn.post loginURL
      teamsnapToken = response.headers['x-teamsnap-token']
      loginHash[:teamsnapToken] = teamsnapToken
    end
    ap loginHash
    return loginHash
  end

  def create_connection(url)
    conn = Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  #
  # Connect to the teamsnap api
  #
  def connect
    url = 'https://api.teamsnap.com/'
    conn = Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger       # <-- Inserts the logger into the connection
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

  #
  # TODO (make the cache support division ids)
  #
  def get_division_team_data(division_id, token = nil)
    Rails.cache.fetch("division_data2-#{division_id}", :expires_in => 60.minutes) do
      get_division_team_data_api(division_id, token)
    end
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
  def get_division_team_data_api(division_id, token = nil)
    division_data = Hash.new
    division_data[:all_teams] = get_all_teams(token)
    playerPayments = TeamsnapPayment.all
    division_data[:all_divisions] =  get_all_divisions(token)
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
                roster = get_roster(team['id'], roster_id, token)
                @roster = roster
                roster
                #rosterId = params[:rosterId]
                #team = get_team(params[:teamId])['team'])
                player = Hash.new
                player[:roster] = roster
                division_team[:player] = preprocess_player_data(roster, playerPayments)
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
  def preprocess_player_data(roster, playerPayments = nil)
    playersHash = Hash.new
    if playerPayments.nil?
      playerPayments = TeamsnapPayment.all
    end
    customThrowingIds = get_customIds('throwing').values
    customFieldingIds = get_customIds('fielding').values
    customRunningIds = get_customIds('baserunning').values
    customHittingIds = get_customIds('hitting').values

    roster.each do |playerData|
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
      if player['division_id'].present?
        player['player_url'] = "https://go.teamsnap.com/#{player['division_id']}/league_roster/edit/#{player['teamsnap_id']}"
      end
      players.push(player)
    end
    players
  end

end