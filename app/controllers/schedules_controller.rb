class SchedulesController < ApplicationController
  

  def index
    @division = Division.eager_load(:teams).find(52)
    teams = ["team1", "team2", "team3", "team4", "team5", "team6", 'teams7', 'teams8']
    generate_games(teams)
  end


  private
    def generate_games(teams)
      init_games(teams)
    end
    def init_games(teams)
      require 'matrix'
      gamesPerWeek = teams.size/2
      ap gamesPerWeek
      vmatchup = []
      hmatchup = []
      teamCount = 0
      for x in 0..1
        for y in 0..(gamesPerWeek-1)
          if (x == 0)
            vmatchup[y] = teams[teamCount]
          elsif (x == 1)
            hmatchup[y] = teams[teamCount]
          end
          teamCount+=1
        end
      end
      ap vmatchup
      ap hmatchup
      ap get_week_games(vmatchup, hmatchup)
      shift_games(vmatchup, hmatchup)
    end

    def shift_games(visitors, home)
      numOfTeams = visitors.size
      vTemp = visitors[1]
      for i in 2..(numOfTeams - 1)
        visitors[i - 1] = visitors[i] 
      end

      visitors[i] = home[i]

      #1 = tem1 --> 2 2 --> 3 3---> 4
      for x in (numOfTeams-1)..1
        home[x] = home[x - 1]
      end
      home[0] = vTemp

      ap visitors
      ap home

    end

    def get_week_games(visitors, home)
      numOfGames = visitors.size
      games = []
      # todo should make sure home and visitors are the same size
      for x in 0..(numOfGames - 1) 
        games.push("#{visitors[x]} vs. #{home[x]}")
      end
      games
    end
end