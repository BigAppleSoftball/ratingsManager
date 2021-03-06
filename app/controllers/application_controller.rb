class ApplicationController < ActionController::Base
  require 'open-uri'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :get_permissions
  protect_from_forgery with: :exception
  include ErrorsHelper
  include SessionsHelper
  include TeamsnapHelper


  Time::DATE_FORMATS[:google_date] = "%Y-%m-%d"
  Time::DATE_FORMATS[:week_date] = "%a, %b %d"
  Time::DATE_FORMATS[:event_date] = "%a, %b %d %l:%M %P"

  helper_method :all_seasons_list
  #
  # Map PermissionNames to Permission Id
  # MUST MATCH ID in Database
  #
  def get_permissions
    permissions = Hash.new
    permissions[:CanEditAllTeams] = 1
    permissions[:CanEditAllPlayers] = 2
    permissions[:CanEditAllSeasons] = 3
    permissions[:CanEditAllDivisions] = 4
    permissions[:CanEditAllRatings] = 5
    permissions[:CanEditAllRoles] = 6
    permissions[:CanEditAllPermissions] = 7
    permissions[:CanImport] = 8
    permissions[:CanApproveRatings] = 10
    @permissions = permissions
  end


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


  def get_park_statuses
    park_statuses = {0 => 'All Open', 1 => 'Some Closed', 2 => 'All Closed'}
    park_statuses
  end

  def get_all_park_statues
    parks = Park.all
    closedCount = 0
    partialCount = 0
    openCount = 0
    numOfparks = parks.length
    parks.each do |park|
      if park.status == 0
        openCount += 1
      elsif park.status == 1
        partialCount += 1
      elsif park.status == 2
        closedCount += 1
      end
    end

    if numOfparks == openCount #all The parks are open
      parkStatus = 0
    elsif numOfparks == closedCount # all the parks are closed
      parkStatus = 2
    else #some are open, closed or partially open
      parkStatus = 1
    end
    parkStatus
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
        if (team.division.present?)
          currentDivision[:id] = team.division_id
          currentDivision[:name] = team.division.description
        end
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


  #
  # Returns an array of team objects by a given season_id
  #
  def get_teams_by_given_season(season_id, order_by = nil)
    divisions = Division.select('id').where(:season_id => params[:season_id])
    divisionIds = Array.new
    # get the divisions in this season
    divisions.each do |division|
      divisionIds.push(division.id)
    end
    if (order_by.nil?)
      teams = Team.select('id,name,division_id').where(:division_id => divisionIds)
    else
      teams = Team.select('id,name,division_id').where(:division_id => divisionIds)
    end
    teams
  end

    #
  # Sets the attendance class for a player row
  #
  def attendance_class(attendance)
    is_attending_class = nil
    if !attendance.nil?
      is_attending = attendance.is_attending
      if is_attending
        is_attending_class = 'is-attending'
      else
        is_attending_class = 'is-not-attending'
      end
    end
    is_attending_class
  end

  #
  # Group's a players ratings into a 
  # hash map that is seperated by the 
  # rating topic
  #
  def rating_to_type_json(rating)
    rating_json = Hash.new
    rating_json[:throwing] = Hash.new
    rating_json[:fielding] = Hash.new
    rating_json[:baserunning] = Hash.new
    rating_json[:hitting] = Hash.new
    # throwing
    rating_json[:throwing][1] = rating[:rating_1]
    rating_json[:throwing][2] = rating[:rating_2]
    rating_json[:throwing][3] = rating[:rating_3]
    rating_json[:throwing][4] = rating[:rating_4]
    rating_json[:throwing][5] = rating[:rating_5]
    # fielding
    rating_json[:fielding][6] = rating[:rating_6]
    rating_json[:fielding][7] = rating[:rating_7]
    rating_json[:fielding][8] = rating[:rating_8]
    rating_json[:fielding][9] = rating[:rating_9]
    rating_json[:fielding][10] = rating[:rating_10]
    rating_json[:fielding][11] = rating[:rating_11]
    rating_json[:fielding][12] = rating[:rating_12]
    rating_json[:fielding][13] = rating[:rating_13]
    rating_json[:fielding][14] = rating[:rating_14]
    # baserunning
    rating_json[:baserunning][15] = rating[:rating_15]
    rating_json[:baserunning][16] = rating[:rating_16]
    rating_json[:baserunning][17] = rating[:rating_17]
    rating_json[:baserunning][18] = rating[:rating_18]
    # hitting
    rating_json[:hitting][19] = rating[:rating_19]
    rating_json[:hitting][20] = rating[:rating_20]
    rating_json[:hitting][21] = rating[:rating_21]
    rating_json[:hitting][22] = rating[:rating_22]
    rating_json[:hitting][23] = rating[:rating_23]
    rating_json[:hitting][24] = rating[:rating_24]
    rating_json[:hitting][25] = rating[:rating_25]
    rating_json[:hitting][26] = rating[:rating_26]
    rating_json[:hitting][27] = rating[:rating_27]
    rating_json
  end

  #
  # Used by impersonate to impersonate a user
  #
  def authenticate_user!
    current_user.is_admin?
  end

  #
  # Team rating is the sum of the top ten player ratings
  #
  def calculate_team_ratings(roster)
    ratings = Array.new
    roster.each do|player|
      if (player && player.profile && player.profile.rating)
        ratings.push(player.profile.rating.total)
      end
    end
    
    top_ratings = ratings.sort.reverse.take(10)
    top_ratings.sum
  end

  #
  # Returns a hashmap that stores rosters and ratings values by team name
  #
  def get_rosters_and_ratings(teams, isAsana = false)
    byName = Hash.new
    byName[:team_names] = Array.new
    byName[:by_name] = Hash.new

    # Load the Roster onto the Team
    teams.each do |team|
      teamId = team.id
      if isAsana
        roster = Roster.eager_load(:profile => :rating).where(:team_id => teamId).order('profiles.last_name')
      else
        roster = Roster.eager_load(:profile => :rating).where(:team_id => teamId).order('profiles.last_name')
      end
      team_name = roster.first().team.name
      byName[:team_names].push(team_name)
      values = Hash.new
      values[:roster] = roster
      values[:rating] = calculate_team_ratings(roster) 
      byName[:by_name][team_name] = values
    end 
    byName
  end

  #
  # Stores lightened colors of rattings sections for use in 
  # excel exports
  #
  def get_col_colors
    col_colors = Hash.new 
    col_colors[:throwing] = '#ccffff'
    col_colors[:hitting] = '#ffcccc'
    col_colors[:running] = '#ccccff'
    col_colors[:fielding] = '#ccffcc'
    col_colors[:none] = '#eeeeee'
    col_colors[:fundamentals] = '#C1C1C0'
    col_colors[:experience] = '#969696'
    col_colors
  end

  def nagaaa_export_values
    table = Hash.new
    questions = Hash.new
    questions[:throwing] = 5
    questions[:fielding] = 9
    questions[:running] = 4
    questions[:hitting] = 9
    total_columns = 27 + 8
    table[:col_colors] = get_col_colors
    table[:questions] = questions
    table[:total_columns] = total_columns
    table
  end

  def asana_export_values
    table = Hash.new
    questions = Hash.new
    questions[:throwing] = 4
    questions[:fielding] = 6
    questions[:running] = 3
    questions[:hitting] = 6
    questions[:fundamentals] = 1
    questions[:experience] = 2
    total_columns = 22 + 8
    table[:col_colors] = get_col_colors
    table[:questions] = questions
    table[:total_columns] = total_columns
    table[:is_asana] = true
    table
  end

  #
  # Takes values to render ratings for given divisions
  #
  def show_ratings(teams, isAsana = false, filename = "ratings")

    if isAsana
      values = get_rosters_and_ratings(teams, true)
      @tableValues = asana_export_values
      @isAsana = true
    else
      values = get_rosters_and_ratings(teams)
      @tableValues = nagaaa_export_values
    end

    @team_names = values[:team_names]
    @valuesByTeamName =values[:by_name]

    respond_to do |format|
      # TODO (Paige) Support rendering Ratings 
      format.html { render layout: 'plain', template: 'divisions/ratings' }
      format.xls do
        response.headers['Content-Type'] = "application/vnd.ms-excel"
        response.headers['Content-Disposition'] = "attachment; filename=\"#{filename}.xls\""
        render 'ratings.xls.haml'
      end
    end
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

