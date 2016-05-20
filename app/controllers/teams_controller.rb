class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_filter :only_for_admin, only: [:destroy, :new]
  before_filter(:only => [:edit, :update]) { only_team_manager params[:id]
                                             only_team_in_active_season params[:id] }

  before_filter(:only => [:show_player_ratings]) { only_team_manager_reps_or_division_reps params[:teamid]}

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.eager_load(:division => :season).includes(:rosters => :profile).where('rosters.is_manager = ?', true).all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @teamSponsors = TeamsSponsor.eager_load(:sponsor).where(:team_id => params[:id])
    @teamsRosters = Roster.includes(:profile => :rating).where(:team_id => params[:id]).order('profiles.last_name')
    @games = Game.eager_load(:home_team, :away_team, :field).where("home_team_id = ? OR away_team_id = ?", params[:id], params[:id]) 
    @team_rating = calculate_team_ratings(@teamsRosters)   
  end

  # GET /teams/new
  def new
    get_form_presets
    @team = Team.new
    if params && params[:division_id]
      @team[:division_id] = params[:division_id].to_i
    end
  end

  # GET /teams/1/edit
  def edit
    get_form_presets
    @rosters = Roster.includes(:profile => :rating).where(:team_id => params[:id]).order('profiles.last_name')
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
    name = @team.name
    division = @team.division
    # get all games played but this team
    games = Game.select('id').where('(home_team_id = ? AND away_team_id is null) OR (away_team_id = ? AND home_team_id is null)', @team.id, @team.id)
    # these games are going to have both teams be null, remove them
    games.destroy_all
    @team.destroy
    respond_to do |format|
      format.html { redirect_to division_path(division), notice: "#{division.description} #{name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  #
  # Get the players ratings
  #
  def show_nagaaa_ratings
    team_id = params[:teamid].to_i
    @team = Team.find_by(:id => team_id)
    teamsRosters = Roster.eager_load(:profile => :rating).where(:team_id => team_id).order('profiles.last_name')
    @teamsRosters = teamsRosters
    @teamRating = calculate_team_ratings(@teamsRosters) 
    @CanEditRatings = has_permissions?(@permissions[:CanEditAllRatings])
    @CanApproveRatings = has_permissions?(@permissions[:CanApproveRatings])
    respond_to do |format|
      ap format
      format.html { render 'ratings' }
      format.csv do
        response.headers['Content-Disposition'] = "attachment; filename=#{@team.name}-#{@team.division.full_name}.csv"
        render 'ratings.csv.haml'
      end
      format.xls do
        response.headers['Content-Type'] = "application/vnd.ms-excel"
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@team.name}_#{@team.division.full_name}.xls\""
        render 'ratings.xls.haml'
      end
    end
  end

  def show_asana_ratings
    @CanEditRatings = has_permissions?(@permissions[:CanEditAllRatings])
    @CanApproveRatings = has_permissions?(@permissions[:CanApproveRatings])
    @isAsana = true
    team_id = params[:teamid]
    @team = Team.find(team_id)
    @teamRoster = Roster.eager_load(:profile => :asana_ratings).where(:team_id => team_id).order('profiles.last_name')
    respond_to do |format|
      format.html { render 'show_asana_ratings' }
      format.csv do
        response.headers['Content-Disposition'] = "attachment; filename=#{@team.name}-#{@team.division.full_name}-asana.csv"
        render 'teams/ratings/asana/export.csv.haml'
      end
    end
  end

  def import_asana_ratings
    @team = Team.find(params[:teamid])
  end

  def run_asana_import
    file = params[:file]['csv']
    teamId = params[:teamId]
    if !(file.nil?)
      # process csv
      CSV.foreach(file.path, headers: true) do |row|

      end
    end
  end

  def update_asana_rating
    isApproved = params[:isApproved]
    ratingId = params[:ratingId]
    response = Hash.new
    current_profile_id = current_user.id
    # find the rating with the id 
    rating = AsanaRating.find(ratingId)
    if rating.present?
      rating[:is_approved] = isApproved
      rating[:approved_profile_id] = current_profile_id
      rating.save
      response[:success] = true
      response[:message] = rating.valid?
      response[:ratingId] = ratingId
      response[:isApproved] = isApproved
    else
      response[:message] = "No Rating Found with Id: #{ratingId}"
    end
    respond_to do |format|
      format.json { render :json=> response}
    end
  end

  #
  # Creates a Json file for player ratings on a team roster
  #
  def get_roster_json(teamsRosters)
    ratings = Hash.new
    teamsRosters.each do |team_roster|
      if team_roster.profile && team_roster.profile.rating
        ratings[team_roster.profile_id] = Hash.new
        ratings[team_roster.profile_id][:ratings] = rating_to_type_json(team_roster.profile.rating)
      end
    end

    ratings.to_json
    ratings
  end

  def get_teams_by_season
    teams = get_teams_by_given_season(params[:season_id].to_i)

    respond_to do |format|
      format.json { render :json=> teams_by_divisions(teams)}
    end
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

  private
    def get_form_presets
      @profiles = Profile.select('first_name, last_name, id').all
      @seasons = Season.select('description, id').all
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.eager_load(:division => :season).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:division_id, :long_name, :stat_loss, :stat_win, :stat_play, :stat_pt_allowed, :stat_pt_scored, :stat_tie, :description, :name, :manager_profile_id, :teamsnap_id)
    end
end
