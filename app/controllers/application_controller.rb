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

  # adds and compiles players rankings
  def preprocess_player_data(roster)
    playersHash = Hash.new
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
