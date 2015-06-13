class SchedulesController < ApplicationController


  def index
    @season = Season.eager_load(:divisions).where(:is_active => true)
    render
  end

  def generate
    @division = Division.eager_load(:teams).find(params[:divisionId])
    @generated_weeks = generate_schedule(@division.teams,15, true)
    render
  end

  def run_generator
    results = Hash.new
    ap params
    divisions = Division.eager_load(:teams).find(params[:divisionId])
    totalGames = params[:totalGames].to_i
    #hasDoubleHeaders = params[:hasDoubleHeaders].to_b
    weeks = generate_schedule(divisions.teams,totalGames, true)
    results[:results_html] = render_to_string "schedules/_generated_weeks.haml", :layout => false, :locals => {:weeks => weeks}
    render :json => results.to_json
  end


  private

    def generate_schedule(division_teams, totalGames = 10, hasDoubleHeaders = false)
      teams = init_teams(division_teams)
      if (teams.size % 2 == 1)
        has_odd_teams = true
      else
        has_odd_teams = false
      end
      ensure_even_number_of_teams(teams)
      matchups = init_games(teams)
      weeks = Array.new
      for week_count in 1.upto(totalGames)
        week = Hash.new
        week[:count] = week_count
        #TODO make sure this is set by and actual value
        week[:games] = get_week_games(matchups, has_odd_teams, has_odd_teams, hasDoubleHeaders)
        weeks.push(week)
        shift_teams(matchups)
      end
      weeks
    end

    def init_teams(teams)
      teams_array = Array.new
      teams.each do |team|
        team_hash = Hash.new
        team_hash[:name] = team.name
        team_hash[:id] = team.id
        teams_array.push(team_hash)
      end
      teams_array
    end

    #
    # If there an an odd number of teams, append a bye week to the end of the list
    #
    def ensure_even_number_of_teams(teams)
      if (teams.size % 2 == 1)
        teams.push(nil)
      end
      nil
    end

    #
    #
    # Initialize the default layout of the games
    # i.e.
    # [0]
    #   Team1
    #   Team2
    #   Team3
    #   Team4
    #
    # [1]
    #   Team5
    #   Team6
    #   Team7
    #   Team8
    #
    def init_games(teams)
      gamesPerWeek = teams.size/2
      matchups = Hash.new
      matchups[0] = []
      matchups[1] = []
      teamCount = 0
      for x in 0..1
        for y in 0..(gamesPerWeek-1)
          matchups[x][y] = teams[teamCount]
          teamCount+=1
        end
      end
      matchups
    end

    #
    #
    # Shift the teams over for the next games
    # i.e.
    # [0]
    #   Team1
    #   Team3
    #   Team4
    #   Team8
    #
    # [2]
    #   Team2
    #   Team5
    #   Team6
    #   Team7
    #
    def shift_teams(matchups)
      numOfTeams = matchups[0].size
      vTemp = matchups[0][1]

      # shift all the left column teams up
      # 0,2 --> 0,1, 0,3 -> 02
      for i in 2..(numOfTeams - 1)
        matchups[0][i - 1] = matchups[0][i]
      end
      # the last left column teams = the last right column team
      matchups[0][numOfTeams - 1] = matchups[1][numOfTeams - 1]

      # shift all the right column games up
      # 1,2 --> 1,3 , 1,2 --> 1,1, 1, 0 --> 1,1
      for x in (numOfTeams - 1 ).downto(0)
        matchups[1][x] = matchups[1][x - 1]
      end
      matchups[1][0] = vTemp
      matchups
    end

    #
    # Set the matchups for this week's games
    #
    def get_week_games(matchups, has_odd_teams = false, has_no_bye = false, has_double_headers = false)
      numOfGames = matchups[0].size
      games = []
      # check to see if their is a BYE Week
      if has_odd_teams && has_no_bye
        # find where the bye week is located
        bye_week_coord = get_bye_week(matchups)
        search_direction = get_search_direction(numOfGames, bye_week_coord)
        split_results = get_split_teams(matchups, bye_week_coord, search_direction)
        split_teams = split_results[:teams]
        split_games = generate_split_games(split_teams[0], split_teams[1], split_teams[2])
        games.push(split_games)
      else
        weeklyMatchups = matchups
      end
      for x in 0..(numOfGames - 1)
        games_set = generate_game(matchups[1][x], matchups[0][x], has_double_headers)
        if games_set.present? # if the game is part of a split game we might get back nothing
          #game[:type] = 'normal'
          games.push(games_set)
          #games += games_set
        end
      end
      games
    end

    #
    # Uses the X,Y coordinates of the bye week to get the 3 teams for the split teams
    # team 1      BYE WEEK
    # team 2      team 3
    #
    def get_split_teams(matchups, bye_week_coordinates, search_direction)
      tempMatchups = Hash.new
      tempMatchups.merge!(matchups)
      x = bye_week_coordinates[0]
      y = bye_week_coordinates[1]
      deltaX = search_direction[0]
      deltaY = search_direction[1]
      team1 = matchups[x + deltaX][y]
      team2 = matchups[x][y + deltaY]
      team3 = matchups[x + deltaX][y + deltaY]

      matchups[x + deltaX][y][:has_split] = true
      matchups[x][y + deltaY][:has_split] = true
      matchups[x + deltaX][y + deltaY][:has_split] = true
      return {:teams =>[team1, team2, team3]}
    end

    #
    # Gets the directions in the grid to get the teams
    #
    def get_search_direction(numOfGames, coord)
      hDirection = 1
      vDirection = 1

      if (coord[0] == 1)
        hDirection = -1
      end

      # if we're in an odd row or at the end of a column
      if (coord[1] % 2 == 1 || coord[1] == (numOfGames - 1))
        vDirection = -1
      end

      return [hDirection, vDirection]
    end

    #
    # Iterates through all the matchups to find the bye week
    # returns the [x,y] locaton of the bye week
    #
    def get_bye_week(matchups)
      numOfGames = matchups[0].size
      for y in 0..(numOfGames - 1)
        if (!matchups[1][y]) # if the team doesn't have an id then this is the bye week
          return [1, y]
        elsif (!matchups[0][y])
          return [0, y]
        end
      end
    end

    #
    # Generates a set of 3 games where 3 teams play each other with a middle split between
    #
    def generate_split_games(team1, team2, team3)
      game1 = generate_game(team1, team2, false, true)[0]
      game2 = generate_game(team2, team3, false, true)[0]
      game3 = generate_game(team3, team1, false, true)[0]

      game1[:type] = 'split'
      game2[:type] = 'split'
      game3[:type] = 'split'
      return [game1, game2, game3]
    end

    #
    # generates normal games
    #
    def generate_game(home, away, has_double_headers = false,  is_split = false)
      if home.blank? && away[:has_split].present?
        away.delete(:has_split)
        return nil
      end

      if away.blank? && home[:has_split].present?
        home.delete(:has_split)
        return nil
      end
      if !is_split && home[:has_split].present? && away[:has_split].present?
        home.delete(:has_split)
        away.delete(:has_split)
        return nil
      else
        games = Array.new
        game1 = Hash.new
        game1[:visitor] = away
        game1[:home] = home
        games.push(game1)
        if has_double_headers
          game2 = {
            :visitor => home,
            :home => away
          }
          games.push(game2)
        end
        games
      end
    end
end