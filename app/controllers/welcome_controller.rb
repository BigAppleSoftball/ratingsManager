class WelcomeController < ApplicationController
  protect_from_forgery


  def index
    puts "RENDERING INDEX"
    @teams = get_all_teams
    render 'index'
  end

  def team
    puts "Showing a certain team"
    @roster = get_roster(params[:teamId], params[:rosterId])
    @playerHash = preprocess_player_data(@roster)
    @rosterId = params[:rosterId]
    @team = get_team(params[:teamId])['team']
    @customIds = get_customIds
    test = Hash.new
    test['here'] = '123123'
    #ap @roster
    #ap @playerHash
    #ap @customIds
    @roster.each do |playerData|
      player = playerData["roster"]
      throwingQ1Id = @customIds['throwing'][1]
      ap throwingQ1Id
      data = @playerHash["#{player['id']}"][:throwing][:ratings][throwingQ1Id]
      ap data
    end
    #ap @customIds['hitting'][81218]
    respond_to do |format|
      format.csv do
        #response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=#{@team['team_name']}-#{@team['team_season']}.csv"
        render 'team.csv.haml'
      end
      format.html

    end
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
