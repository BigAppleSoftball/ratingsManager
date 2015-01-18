class WelcomeController < ApplicationController
  token =
  def index
    log_in_to_teamsnap
    @teams = get_all_teams
    render 'index'
  end

  def team
    puts "Showing a certain team"
    @roster = get_roster(params[:teamId], params[:rosterId])
    @rosterId = params[:rosterId]
    @teamId = params[:teamId]
    render 'team'
  end

  def ranking
    player = get_roster_player(params[:teamId], params[:rosterId], params[:playerId])
    if player
      @player = player['roster']
    end
    puts @player
    render 'ranking'
  end
end
