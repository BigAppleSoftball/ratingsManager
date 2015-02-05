class WelcomeController < ApplicationController
  protect_from_forgery


  def index
    @teamsByDivision = get_all_teams
    render 'index'
  end

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

  # current format
  #Division,Team,Player,DOB,Rating,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27
  def generate_roster_csv_rows(playerHash, customIds, roster, team)
    playerArray = Array.new
    throwingQs = @customIds['throwing'].keys
    fieldingQs = @customIds['fielding'].keys
    baserunningQs = @customIds['baserunning'].keys
    hittingQs = @customIds['hitting'].keys
    teamName = team['team_name']
    teamDivision = team['team_division']
    roster.each do |playerData|
      player = playerData["roster"]
      playerName = "#{player['first']} #{player['last']}"
      playerRating = playerHash["#{player['id']}"][:fullRating]
      playerBirthday = player['birthdate']
      playerThrowingData = playerHash["#{player['id']}"][:throwing][:ratings]
      playerFieldingData = playerHash["#{player['id']}"][:fielding][:ratings]
      playerHittingData = playerHash["#{player['id']}"][:hitting][:ratings]
      playerRunningData = playerHash["#{player['id']}"][:running][:ratings]
      throwingString = ""
      fieldingString = ""
      runningString = ""
      hittingString = ""
      throwingQs.each do |throwingQ|
        questionCustomId = customIds['throwing'][throwingQ]
        throwingString += "#{playerThrowingData[questionCustomId]},"
      end
      fieldingQs.each do |fieldingQ|
        questionCustomId = customIds['fielding'][fieldingQ]
        fieldingString += "#{playerFieldingData[questionCustomId]},"
      end
      baserunningQs.each do |runningQ|
        questionCustomId = customIds['baserunning'][runningQ]
        runningString += "#{playerRunningData[questionCustomId]},"
      end
      hittingQs.each do |hittingQ|
        questionCustomId = customIds['hitting'][hittingQ]
        hittingString += "#{playerHittingData[questionCustomId]},"
      end
      playerArray.push("#{teamDivision},#{teamName},#{playerName},#{playerBirthday},#{playerRating},#{throwingString}#{fieldingString}#{runningString}#{hittingString}")
    end
    playerArray
  end

  def ranking
    player = get_roster_player(params[:teamId], params[:rosterId], params[:playerId])
    if player
      @player = player['roster']
    end
    render 'ranking'
  end

  def login
    # check if user is logged in already (redirect them if so)
    if get_token_cookie.nil?
      render 'login'
    else
      redirect_to action: "index"
    end
  end

  def logout
    log_out_user
    flash[:notice] = 'You have been Logged out.'
    redirect_to action: "login"
  end


  def teamsnaplogin
    loginResponse = log_in_to_teamsnap(params[:email], params[:password])
    respond_to do |format|
      format.json { render :json=> loginResponse}
    end
  end

  def error403
    render '403'
  end
end
