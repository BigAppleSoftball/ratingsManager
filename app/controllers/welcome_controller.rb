class WelcomeController < ApplicationController
  #protect_from_forgery
  after_action :set_access_control_headers

  #def index
  #  @all_teams = get_all_teams
  #  @divisions = get_all_divisions
  #  render 'index'
  #end

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

  def error403
    render '403'
  end

  def basl_sidebar
    @sponsors = Sponsor.where(:show_carousel => true)
    @parkStatus = get_all_park_statues
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def load_calendar
    time = Time.now.beginning_of_week
    maxDate = (time + 6.months)
    # convert times to google supported format for api query
    timeNow = "#{time.to_formatted_s(:google_date)}T00:00:00-05:00"
    timeMax = "#{maxDate.to_formatted_s(:google_date)}T00:00:00-05:00"

    # make request to google api
    googleResponse = RestClient.get "https://www.googleapis.com/calendar/v3/calendars/secretary@bigapplesoftball.com/events?key=AIzaSyCoGxbgo50sQ98aSQxXUwyeZexTwkWYUlI&singleEvents=true&timeMin=#{timeNow}&timeMax=#{timeMax}"
    googleResponseAsJson = JSON.parse(googleResponse)

    # convert all dates to a universal ruby on rails date object
    googleResponseAsJson['items'].each do |event|
      eventStart = event['start']['dateTime'] || event['start']['date']
      if eventStart
        event['startDate'] = eventStart.to_time
      else
      end
    end

    googleEvents = googleResponseAsJson['items'].sort_by { |a| a['startDate'] }
    startTime = time
    endTime = maxDate
    weeks = Array.new
    count = 0

    while (startTime < endTime && (count < googleEvents.length - 1))
      weekEndTime =  startTime + 6.days
      week = Hash.new
      week[:startTime] = startTime
      week[:endTime] = weekEndTime
      week[:events] = Array.new

      while (startTime <= googleEvents[count]['startDate'] && weekEndTime.end_of_day >= googleEvents[count]['startDate'] && (count < googleEvents.length - 1))
        week[:events].push(googleEvents[count])
        count += 1
      end
      weeks.push(week)
      startTime = startTime + 1.week
    end

    @weeks = weeks

    render :layout => false
  end


  def event_date_to_system(event)
    firstEventStart = event['start']['dateTime'] || event['start']['date']
    firstEventStart.to_time
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end
end
