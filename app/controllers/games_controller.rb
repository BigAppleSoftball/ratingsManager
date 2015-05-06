class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @seasons = Season.all
  end
  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
    get_universal_game_variables
    # if there is a division in the params get the season
    if (params[:division_id])
      division = Division.find_by( :id =>params[:division_id].to_i)
      ap division
      if !division.nil? 
        @selected_season_id = division.season_id
        @teamsByDivision = get_teams_by_division(params[:division_id].to_i)
        @seasons = Array.new
        @seasons.push(division.season)
      end
    end
  end

  # GET /games/1/edit
  def edit
    @selected_season_id = 0
    # if its a game with a home OR an away team it already has a set season, get it to reflect it in the edit screen
    if (@game.home_team_id) 
      @selected_season_id = @game.home_team.division.season.id
    elsif (@game.away_team_id)
      @selected_season_id = @game.away_team.division.season.id
    end
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def game_attendance
    teamId = params[:teamid].to_i
    set_game
    if teamId == @game.home_team_id || teamId == @game.away_team_id
      @team = Team.where(:id => teamId)
      if !@team.nil?
        @roster = Roster.where(:team_id => teamId)
        @attendance = GameAttendance.where(:game_id => @game.id)
      end
    end
    # make sure team is on one of the games
    render 'show'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
      @teamsByDivision = get_all_teams_by_division
      get_universal_game_variables
    end

    def get_universal_game_variables
      @seasons = Season.all
      @fields = Field.where(:is_active => true)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:day_id, :start_time, :home_team_id, :integer, :away_team_id, :is_flip, :field_id, :home_score, :away_score, :is_rainout, :is_active)
    end
end
