class ApplicationController < ActionController::Base
  require 'open-uri'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ErrorsHelper
  include SessionsHelper
  include TeamsnapHelper

  Time::DATE_FORMATS[:google_date] = "%Y-%m-%d"
  Time::DATE_FORMATS[:week_date] = "%a, %b %d"
  Time::DATE_FORMATS[:event_date] = "%a, %b %d %l:%M %P"

  helper_method :all_seasons_list


  #--------------------------------------------
  #
  #   Seasons
  #
  #--------------------------------------------

  #
  # If the user has edited a season we want to clear the season cache
  #
  def clear_seasons_cache
    Rails.cache.delete('all_seasons_by_status_list')
  end

  #
  # Caches all the seasons listed
  #
  def all_seasons_list
    Rails.cache.fetch("all_seasons_by_status_list", :expires_in => 60.minutes) do
      get_all_seasons_by_status
    end
  end

  #
  # gets all the seasons in the database and orders them
  # based on status
  #
  def get_all_seasons_by_status
    dateNow = DateTime.now.end_of_day
    all_seasons = Hash.new
    all_seasons[:upcoming] = Array.new
    all_seasons[:current] = Array.new
    all_seasons[:past] = Array.new
    seasons = Season.all

    seasons.each do |season|
      if (season.is_active) # current or upcoming season
        # going to assume if today is part the season end date that the league owner intentionally wanted the season to be current
        if (season.date_start <= dateNow)
          all_seasons[:current].push(season)
        else
          all_seasons[:upcoming].push(season)
        end
      else # past season
        all_seasons[:past].push(season)
      end
    end
    all_seasons
  end

  # TODO get rid of old teamsnap crap
  def get_all_divisions
    Rails.cache.fetch("all_divisions", :expires_in => 60.minutes) do
      get_divisions
    end
  end

  # TODO get rid of old teamsnap crap
  def get_divisions
    divisionsURL = "https://api.teamsnap.com/v2/divisions/16139"
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => cookies[:teamsnap_token]}
    response = conn.get divisionsURL
    JSON.parse(response.body)
  end

  #todo get rid of old teamsnap crap
  def get_roster(teamId, rosterId)
    rosterURL = "https://api.teamsnap.com/v2/teams/#{teamId}/as_roster/#{rosterId}/rosters"
    conn = connect
    conn.headers = {'Content-Type'=> 'application/json', 'X-Teamsnap-Token' => cookies[:teamsnap_token]}
    response = conn.get rosterURL
    JSON.parse(response.body)
  end


  #
  # Returns an array of teams_ids managed by the current user
  #
  def get_team_managed_by_profile
    rosters = Roster.select('team_id').where(:profile_id => current_profile.id, :is_manager => true)
    rosters_team_ids = rosters.collect{|u| u.team_id}
    rosters_team_ids
  end

  #--------------------------------------------
  #
  #   Sidebar
  #
  #--------------------------------------------


  def get_field_statuses
    field_statuses = {0 => 'All Open', 1 => 'Some Closed', 2 => 'All Closed'}
    field_statuses
  end

  def get_all_field_statues
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
      fieldStatus = 0
    elsif numOfFields == closedCount # all the fields are closed
      fieldStatus = 2
    else #some are open, closed or partially open
      fieldStatus = 1
    end
    fieldStatus
  end


  #--------------------------------------------
  #
  #   Teams
  #
  #--------------------------------------------

  # Gets all the teams and orders them by division
  def get_all_teams_by_division
    teams = Team.order('division_id ASC').all
    teams_by_divisions(teams)
  end

  def get_teams_by_division(divisionIds)
    teams = Team.where(:division_id => divisionIds).order('division_id ASC').all
    teams_by_divisions(teams)
  end

  def teams_by_divisions(teams)
    teamsByDivision = Array.new
    currentDivision = Hash.new
    currentDivision[:id] = 0
    currentDivision[:teams] = Array.new
    teams.each do |team|
      if currentDivision[:id] != team.division_id
        if currentDivision[:teams].length > 0
          teamsByDivision.push(currentDivision)
        end
        currentDivision = Hash.new
        currentDivision[:id] = team.division_id
        currentDivision[:name] = team.division.description
        currentDivision[:teams] = Array.new
      end
      currentDivision[:teams].push(team)
    end
    teamsByDivision.push(currentDivision)
    teamsByDivision
  end

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

private

  # Finds the User with the ID stored in the session with the key
  # :current_user_id This is a common way to handle user login in
  # a Rails application; logging in sets the session value and
  # logging out removes it.
  def set_current_user(user_data)
    session[:current_user_id] = user_data
  end

end

