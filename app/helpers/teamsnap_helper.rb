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
    response = conn.get teamsURL
    preprocess_team_data(JSON.parse(response.body))
  end

    #
  # Log user into the teamsnap api (return status)
  #
  def log_in_to_teamsnap(username, password)
    ap username
    ap password
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

end