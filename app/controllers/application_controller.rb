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

  def log_in_to_teamsnap(username, password)
    loginURL = 'https://api.teamsnap.com/v2/authentication/login/'
    conn = connect
    loginHash = Hash.new
    if cookies[:teamsnap_token].nil?
      conn.params  = {'user' => username, 'password' => password}
      conn.headers = {'Content-Type'=> 'application/json'}
      response = conn.post loginURL
      puts response.headers['x-teamsnap-token']
      loginHash[:status] = response.headers['status']
      loginHash[:message] = response.headers['x-rack-cache']
      teamsnapToken = response.headers['x-teamsnap-token']
      if teamsnapToken.nil?
        loginHash[:failed] = true
      else
        loginHash[:success] = true
        cookies[:teamsnap_token] = teamsnapToken
      end
    end
    loginHash
  end

  def get_all_teams
    teamsURL = 'https://api.teamsnap.com/v2/teams'
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => cookies[:teamsnap_token]}
    response = conn.get teamsURL
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

  def get_roster_player(teamId, rosterId, playerId)
    rosterPlayerURL = "https://api.teamsnap.com/v2/teams/#{teamId}/as_roster/#{rosterId}/rosters/#{playerId}"
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => cookies[:teamsnap_token]}
    response = conn.get rosterPlayerURL
    JSON.parse(response.body)
  end

  def get_customIds(ratingSection = nil)
    customHash = Hash.new
    customHash['throwing'] = Hash.new
    customHash['throwing'][81159] = 1
    customHash['throwing'][81165] = 2
    customHash['throwing'][81166] = 3
    customHash['throwing'][81169] = 4
    customHash['throwing'][81170] = 5
    customHash['throwing'][1] = 81159
    customHash['throwing'][2] = 81165
    customHash['throwing'][3] = 81166
    customHash['throwing'][4] = 81169
    customHash['throwing'][5] = 81170
    customHash['fielding'] = Hash.new
    customHash['fielding'][81173] = 6
    customHash['fielding'][81175] = 7
    customHash['fielding'][81176] = 8
    customHash['fielding'][81178] = 9
    customHash['fielding'][81181] = 10
    customHash['fielding'][81187] = 11
    customHash['fielding'][81190] = 12
    customHash['fielding'][81193] = 13
    customHash['fielding'][81196] = 14
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
    customHash['baserunning'][81198] = 15
    customHash['baserunning'][81199] = 16
    customHash['baserunning'][81201] = 17
    customHash['baserunning'][81204] = 18
    customHash['hitting'] = Hash.new
    customHash['hitting'][81207] = 19
    customHash['hitting'][81210] = 20
    customHash['hitting'][81212] = 21
    customHash['hitting'][81215] = 22
    customHash['hitting'][81218] = 23
    customHash['hitting'][81223] = 24
    customHash['hitting'][81224] = 25
    customHash['hitting'][81225] = 26
    customHash['hitting'][81226] = 27
    if (ratingSection.nil?)
      customHash
    else
      customHash[ratingSection]
    end
  end

  # adds and compiles players rankings
  def preprocess_player_data(roster)
    playersHash = Hash.new
    customThrowingIds = get_customIds('throwing').keys
    customFieldingIds = get_customIds('fielding').keys
    customRunningIds = get_customIds('baserunning').keys
    customHittingIds = get_customIds('hitting').keys

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
end

def get_token_cookie
  cookies[:teamsnap_token]
end


#curl -X POST -H "Content-Type: application/json" -H "X-Teamsnap-Token: ca661de3-e8ee-4df6-a536-3a79318c27ac" -k "https://api.teamsnap.com/v2/teams/363571/as_roster/4311961"
#
#3curl -X GET -H "Content-Type: application/json" -H "X-Teamsnap-Token: ca661de3-e8ee-4df6-a536-3a79318c27ac" -D - -k https://api.teamsnap.com/v2/teams
