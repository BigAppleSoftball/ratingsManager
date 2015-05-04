class TeamsnapController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_filter :verify_authenticity_token, :only => [:import_season_data]

  include TeamsnapHelper
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
  # Log into the teamsnap api
  # End point for javascript ajax call
  #
  def teamsnaplogin
    loginResponse = log_in_to_teamsnap(params[:email], params[:password])
    respond_to do |format|
      format.json { render :json=> loginResponse}
    end
  end

  #
  # Render the login view
  #
  def login
    # check if user is logged in already (redirect them if so)
    if get_token_cookie.nil?
      render 'login'
    else
      redirect_to action: 'index'
    end
  end

  def redirect
    if get_token_cookie.nil?
      render 'login'
    else
      redirect_to action: 'index'
    end
  end

  #
  # Shows the listing of teams by division
  #
  def index
    @teamsByDivision = get_all_teams
    @teamsnapDivisions = teamsnap_divs_by_id
  end

  #
  # Log the User out of teamsnap
  #
  def logout
    log_out_user
    flash[:notice] = 'You have been Logged out of teamsnap.'
    redirect_to action: "login"
  end



  #
  # Rnder the single team view
  #
  def team
    teamRatingLimit = 10 #we only want to rate the 10 highest Players
    @teamRating = 0
    @roster = get_roster(params[:teamId], params[:rosterId])
    @rosterId = params[:rosterId]
    @team = get_team(params[:teamId])['team']
    @playerHash = preprocess_player_data(@roster)
    @playerHash.sort_by{|k,v| v[:fullRating]}.reverse!.first(10).each do |player|
      @teamRating += player[1][:fullRating]
    end
    @teamRating
    @customIds = get_customIds
    respond_to do |format|
      format.csv do
        @playerRows = generate_roster_csv_rows(@playerHash, @customIds, @roster, @team)
        response.headers['Content-Disposition'] = "attachment; filename=#{@team['team_name']}-#{@team['team_season']}.csv"
        render 'team.csv.haml'
      end
      format.html

    end
  end

  #
  # Get ranking data
  #
  def ranking
    player = get_roster_player(params[:teamId], params[:rosterId], params[:playerId])
    if player
      @player = player['roster']
    end
    render 'ranking'
  end

  
  #
  # DEPRECATED (Get user name based on admins added by email)
  #
  def set_admin(username)
    admins = Admin.where(:email => username)
    cookies[:teamsnap_is_admin] = (admins.length > 0)
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

  def get_token_cookie
    cookies[:teamsnap_token]
  end


  def log_out_user
    cookies.delete :teamsnap_token
    cookies.delete :teamsnap_is_admin
  end

  def import_divisions
    # get teamsnap account
    #latest_account = TeamsnapScanAccount.order('created_at DESC').first
    # log into teamsnap api
    #log_in_to_teamsnap(latest_account.username, latest_account.password)
    # get the divisions
    @divisions = teamsnap_divisions_to_objects(get_all_divisions, get_all_teams)
    @seasons = Season.all
  end

  def import_season_data
    ap 'Running season import'
    ap params
    ap params['season_id']
    run_import(params['season_id'].to_i)
  end

end