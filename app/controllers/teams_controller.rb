class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_filter :only_for_admin, only: [:edit, :update, :destroy, :new]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all

  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    teams_sponsors = TeamsSponsor.where(:team_id => params[:id])
    @teamSponsors = Array.new
    teams_sponsors.each do |team_sponsor|
      @teamSponsors.push(team_sponsor)
    end
    rosters = Roster.where(:team_id => params[:id])
    @teamsRosters = Array.new
    rosters.each do |roster|
      @teamsRosters.push(roster)
    end
  end

  # GET /teams/new
  def new
    get_form_presets
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    get_form_presets
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


  def get_teams_by_season
    divisions = Division.select('id').where(:season_id => params[:season_id])
    divisionIds = Array.new
    divisions.each do |division|
      divisionIds.push(division.id)
    end
    respond_to do |format|
      format.json { render :json=> teams}
    end
  end

  private
    def get_form_presets
      @profiles = Profile.all
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:division_id, :long_name, :stat_loss, :stat_win, :stat_play, :stat_pt_allowed, :stat_pt_scored, :stat_tie, :description, :name, :manager_profile_id)
    end
end
