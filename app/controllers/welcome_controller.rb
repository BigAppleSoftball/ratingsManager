class WelcomeController < ApplicationController
  protect_from_forgery

  def index
    @teams = get_all_teams
    render 'index'
  end

  def team
    puts "Showing a certain team"
    @roster = get_roster(params[:teamId], params[:rosterId])
    @playerHash = preprocess_player_data(@roster)
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

  def login
    # check if user is logged in already (redirect them if so)
    if get_token_cookie.nil?
      render 'login'
    else
      redirect_to root_path
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
