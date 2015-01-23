class WelcomeController < ApplicationController
  protect_from_forgery


  def index
    puts "RENDERING INDEX"
    @teams = get_all_teams
    render 'index'
  end

  def team
    puts "Showing a certain team"
    teamRatingLimit = 10 #we only want to rate the 10 highest Players
    @teamRating = 0
    @roster = get_roster(params[:teamId], params[:rosterId])
    @playerHash = preprocess_player_data(@roster)
    @rosterId = params[:rosterId]
    @team = get_team(params[:teamId])['team']
    @playerHash.sort_by{|k,v| v[:fullRating]}.reverse!.first(10).each do |player|
      @teamRating += player[1][:fullRating]
    end
    @teamRating
    @customIds = get_customIds
    respond_to do |format|
      format.csv do
        @playerRows = generate_roster_csv_rows(@playerHash, @customIds, @roster)
        response.headers['Content-Disposition'] = "attachment; filename=#{@team['team_name']}-#{@team['team_season']}.csv"
        render 'team.csv.haml'
      end
      format.html

    end
  end

  def generate_roster_csv_rows(playerHash, customIds, roster)
    playerArray = Array.new
    throwingQs = @customIds['throwing'].keys
    fieldingQs = @customIds['fielding'].keys
    baserunningQs = @customIds['baserunning'].keys
    hittingQs = @customIds['hitting'].keys
    roster.each do |playerData|
      player = playerData["roster"]
      playerName = "#{player['first']} #{player['last']}"
      playerRating = playerHash["#{player['id']}"][:fullRating]
      playerThrowingData = playerHash["#{player['id']}"][:throwing][:ratings]
      playerFieldingData = playerHash["#{player['id']}"][:fielding][:ratings]
      playerHittingData = playerHash["#{player['id']}"][:hitting][:ratings]
      playerRunningData = playerHash["#{player['id']}"][:running][:ratings]
      throwingString = ""
      fieldingString = ""
      runningString = ""
      hittingString = ""
      throwingQs.each do |throwingQ| #an array of 1, 2, 3, 4 the question ids
        questionCustomId = customIds['throwing'][throwingQ]
        throwingString += "#{playerThrowingData[questionCustomId]},"
      end
      fieldingQs.each do |fieldingQ|
        questionCustomId = customIds['fielding'][fieldingQ]
        fieldingString += "#{playerFieldingData[questionCustomId]},"
      end
      baserunningQs.each do |runningQ|
        questionCustomId = customIds['baserunning'][runningQ]
        puts questionCustomId
        puts
        runningString += "#{playerRunningData[questionCustomId]},"
      end
      hittingQs.each do |hittingQ|
        questionCustomId = customIds['hitting'][hittingQ]
        hittingString += "#{playerHittingData[questionCustomId]},"
      end
      playerArray.push("#{playerName},#{throwingString}#{fieldingString}#{runningString}#{hittingString}#{playerRating}")
    end
    playerArray
  end

  def ranking
    player = get_roster_player(params[:teamId], params[:rosterId], params[:playerId])
    if player
      @player = player['roster']
    end
    puts @player
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

  def teamsnaplogin
    puts params
    loginResponse = log_in_to_teamsnap(params[:email], params[:password])
    respond_to do |format|
      format.json { render :json=> loginResponse}
    end
  end
end
