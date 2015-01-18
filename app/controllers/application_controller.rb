class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def connect
    url = 'https://api.teamsnap.com/'
    conn = Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def log_in_to_teamsnap
    username = "paigepon@gmail.com"
    password = "buffysummers"
    loginURL = 'https://api.teamsnap.com/v2/authentication/login/'
    conn = connect
    if cookies[:teamsnap_token].nil?
      puts "LOGINING IN TeamsnapToken #{config.teamsnapToken}"
      conn.params  = {'user' => username, 'password' => password}
      conn.headers = {'Content-Type'=> 'application/json'}
      response = conn.post loginURL
      puts response.headers['x-teamsnap-token']
      cookies[:teamsnap_token] = response.headers['x-teamsnap-token']
    end
  end

  def get_all_teams
    teamsURL = 'https://api.teamsnap.com/v2/teams'
    conn = connect
    puts "LOGINING IN TeamsnapToken #{config.teamsnapToken}"
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

  def get_roster_player(teamId, rosterId, playerId)
    rosterPlayerURL = "https://api.teamsnap.com/v2/teams/#{teamId}/as_roster/#{rosterId}/rosters/#{playerId}"
    puts rosterPlayerURL
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => cookies[:teamsnap_token]}
    response = conn.get rosterPlayerURL
    JSON.parse(response.body)
  end


end

#curl -X POST -H "Content-Type: application/json" -H "X-Teamsnap-Token: ca661de3-e8ee-4df6-a536-3a79318c27ac" -k "https://api.teamsnap.com/v2/teams/363571/as_roster/4311961"
#
#3curl -X GET -H "Content-Type: application/json" -H "X-Teamsnap-Token: ca661de3-e8ee-4df6-a536-3a79318c27ac" -D - -k https://api.teamsnap.com/v2/teams
