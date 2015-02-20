class WelcomeController < ApplicationController
  #protect_from_forgery
  after_action :set_access_control_headers
  Time::DATE_FORMATS[:google_date] = "%Y-%m-%d"

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

  def basl_sidebar
    @sponsors = Sponsor.where(:show_carousel => true)
    fields = Field.all
    closedCount = 0
    partialCount = 0
    openCount = 0
    numOfFields = fields.length
    fields.each do |field|
      if field.status == 0
        openCount += 1
      elsif field.status == 1
        partialCount += 1
      elsif field.status == 2
        closedCount += 1
      end
    end

    if numOfFields == openCount #all The fields are open
      @fieldStatus = 0
    elsif numOfFields == closedCount # all the fields are closed
      @fieldStatus = 2
    else #some are open, closed or partially open
      @fieldStatus = 1
    end
    #@fieldsClosed = Field.where(:status => 2)
    #@fieldsParitallyClosed = Field.where(:status => 1)
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def load_calendar
    time = Time.now
    maxDate = (time + 6.months)
    timeNow = "#{time.to_formatted_s(:google_date)}T00:00:00-05:00"

    #ap maxDate.strftime('%Y-%M-%d')
    timeMax = "#{maxDate.to_formatted_s(:google_date)}T00:00:00-05:00"
    ap timeNow
    ap timeMax
    response = RestClient.get "https://www.googleapis.com/calendar/v3/calendars/secretary@bigapplesoftball.com/events?key=AIzaSyCoGxbgo50sQ98aSQxXUwyeZexTwkWYUlI&singleEvents=true&timeMin=#{timeNow}&timeMax=#{timeMax}"
    responseAsJson = JSON.parse(response)
    #ap responseAsJson
    @events = responseAsJson
    render :layout => false
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end
end
