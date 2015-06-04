class SchedulesController < ApplicationController
  

  def index
    @division = Division.eager_load(:teams).find(52)
    teams = ["team1", "team2", "team3", "team4", "team5", "team6", 'teams7', 'teams8']
    @generated_weeks = generate_schedule(@division.teams.pluck('teams.name, teams.id'), 10)
    render
  end


  private

    def generate_schedule(teams, totalGames)
      matchups = init_games(teams)
      weeks = Array.new
      for week_count in 1.upto(totalGames)
        week = Hash.new
        week[:count] = week_count
        week[:games] = get_week_games(matchups)
        weeks.push(week)
        matchups = shift_teams(matchups)
      end
      weeks
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

    def get_week_games(matchups)
      numOfGames = matchups[0].size
      games = []
      # todo should make sure home and visitors are the same size
      for x in 0..(numOfGames - 1) 
        game = Hash.new
        game[:visitor] = matchups[0][x]
        game[:home] = matchups[1][x]
        games.push(game)
      end
      games
    end
end