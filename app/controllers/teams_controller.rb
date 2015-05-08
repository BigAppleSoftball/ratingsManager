class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_filter :only_for_admin, only: [:destroy, :new]
  before_filter(:only => [:edit, :update]) { only_team_manager params[:id]
                                             only_team_in_active_season params[:id] }

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.eager_load(:division).includes(:rosters => :profile).where('rosters.is_manager = 1').all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @teamSponsors = TeamsSponsor.eager_load(:sponsor).where(:team_id => params[:id])
    @teamsRosters = Roster.includes(:profile => :rating).where(:team_id => params[:id])
    @games = Game.eager_load(:home_team, :away_team, :field).where("home_team_id = ? OR away_team_id = ?", params[:id], params[:id])    
  end

  # GET /teams/new
  def new
    get_form_presets
    @team = Team.new
    if params && params[:division_id]
      @team[:division_id] = params[:division_id].to_i
    end
    ap @team
  end

  # GET /teams/1/edit
  def edit
    get_form_presets
    @rosters = Roster.where(:team_id => params[:id])
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #
  # Get the players ratings
  #
  def show_player_ratings
    team_id = params[:teamid].to_i
    @team = Team.find_by(:id => team_id)
    teamsRosters = Roster.eager_load(:profile => :rating).where(:team_id => team_id)
    @teamsRosters = teamsRosters
    @ratings_json = get_roster_json(teamsRosters).to_json
    render 'ratings'
  end

  #
  # Creates a Json file for player ratings on a team roster
  #
  def get_roster_json(teamsRosters)
    ratings = Hash.new
    teamsRosters.each do |team_roster|
      rating_json = Hash.new
      if team_roster.profile && team_roster.profile.rating
        rating_json[:throwing] = Hash.new
        rating_json[:fielding] = Hash.new
        rating_json[:baserunning] = Hash.new
        rating_json[:hitting] = Hash.new
        # throwing
        rating_json[:throwing][1] = team_roster.profile.rating[:rating_1]
        rating_json[:throwing][2] = team_roster.profile.rating[:rating_2]
        rating_json[:throwing][3] = team_roster.profile.rating[:rating_3]
        rating_json[:throwing][4] = team_roster.profile.rating[:rating_4]
        rating_json[:throwing][5] = team_roster.profile.rating[:rating_5]
        # fielding
        rating_json[:fielding][6] = team_roster.profile.rating[:rating_6]
        rating_json[:fielding][7] = team_roster.profile.rating[:rating_7]
        rating_json[:fielding][8] = team_roster.profile.rating[:rating_8]
        rating_json[:fielding][9] = team_roster.profile.rating[:rating_9]
        rating_json[:fielding][10] = team_roster.profile.rating[:rating_10]
        rating_json[:fielding][11] = team_roster.profile.rating[:rating_11]
        rating_json[:fielding][12] = team_roster.profile.rating[:rating_12]
        rating_json[:fielding][13] = team_roster.profile.rating[:rating_13]
        rating_json[:fielding][14] = team_roster.profile.rating[:rating_14]
        # baserunning
        rating_json[:baserunning][15] = team_roster.profile.rating[:rating_15]
        rating_json[:baserunning][16] = team_roster.profile.rating[:rating_16]
        rating_json[:baserunning][17] = team_roster.profile.rating[:rating_17]
        rating_json[:baserunning][18] = team_roster.profile.rating[:rating_18]
        # hitting
        rating_json[:hitting][19] = team_roster.profile.rating[:rating_19]
        rating_json[:hitting][20] = team_roster.profile.rating[:rating_20]
        rating_json[:hitting][21] = team_roster.profile.rating[:rating_21]
        rating_json[:hitting][22] = team_roster.profile.rating[:rating_22]
        rating_json[:hitting][23] = team_roster.profile.rating[:rating_23]
        rating_json[:hitting][24] = team_roster.profile.rating[:rating_24]
        rating_json[:hitting][25] = team_roster.profile.rating[:rating_25]
        rating_json[:hitting][26] = team_roster.profile.rating[:rating_26]
        rating_json[:hitting][27] = team_roster.profile.rating[:rating_27]
        ratings[team_roster.profile_id] = Hash.new
        ratings[team_roster.profile_id][:ratings] = rating_json
      end
    end
    ap ratings.to_json
    ratings.to_json
    ratings
  end


  def get_teams_by_season
    teams = get_teams_by_given_season(params[:season_id].to_i)

    respond_to do |format|
      format.json { render :json=> teams_by_divisions(teams)}
    end
  end

  private
    def get_form_presets
      @profiles = Profile.all
      @seasons = Season.all
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:division_id, :long_name, :stat_loss, :stat_win, :stat_play, :stat_pt_allowed, :stat_pt_scored, :stat_tie, :description, :name, :manager_profile_id, :teamsnap_id)
    end
end
