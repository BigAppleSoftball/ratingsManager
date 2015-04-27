class TeamsSponsorsController < ApplicationController
  before_action :set_teams_sponsor, only: [:show, :edit, :update, :destroy]
  before_filter :only_for_admin, only: [:edit, :update, :destroy]

  # GET /teams_sponsors
  # GET /teams_sponsors.json
  def index
    @seasons = Season.all
    #@teams_sponsors = TeamsSponsor.all
  end

  # GET /teams_sponsors/1
  # GET /teams_sponsors/1.json
  def show
  end

  # GET /teams_sponsors/new
  def new
    set_univeral_params
    @teams_sponsor = TeamsSponsor.new
  end

  # GET /teams_sponsors/1/edit
  def edit
    set_univeral_params
  end

  # POST /teams_sponsors
  # POST /teams_sponsors.json
  def create
    @teams_sponsor = TeamsSponsor.new(teams_sponsor_params)

    respond_to do |format|
      if @teams_sponsor.save
        format.html { redirect_to @teams_sponsor, notice: 'Teams sponsor was successfully created.' }
        format.json { render :show, status: :created, location: @teams_sponsor }
      else
        format.html { render :new }
        format.json { render json: @teams_sponsor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams_sponsors/1
  # PATCH/PUT /teams_sponsors/1.json
  def update
    respond_to do |format|
      if @teams_sponsor.update(teams_sponsor_params)
        format.html { redirect_to @teams_sponsor, notice: 'Teams sponsor was successfully updated.' }
        format.json { render :show, status: :ok, location: @teams_sponsor }
      else
        format.html { render :edit }
        format.json { render json: @teams_sponsor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams_sponsors/1
  # DELETE /teams_sponsors/1.json
  def destroy
    @teams_sponsor.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: "Teams sponsor for #{@teams_sponsor.team.name} was successfully removed." }
      format.json { head :no_content }
    end
  end

  #
  # Shows the list of sponsors in a season
  #
  def season_sponsors
    season_id = params[:season_id].to_i
    @season = Season.find_by(:id => season_id)
    season_teams = get_teams_by_given_season(season_id, true)
    # get the list of teams in ever division
    season_team_ids = Array.new
    
    season_teams.each do |team|
      season_team_ids.push(team.id)
    end
    
    teams_sponsors = TeamsSponsor.where(:team_id => season_team_ids)
    @team_sponsors = sponsors_by_team(teams_sponsors)
  end

  def sponsors_by_team(teams_sponsors)
    sponsored_teams = Hash.new
    current_team_id = 0
    teams_sponsors.each do |team_sponsor|
      if current_team_id != team_sponsor.team_id
        current_team_id = team_sponsor.team_id
        
        if (sponsored_teams[team_sponsor.team.name].nil?)
          sponsored_teams[team_sponsor.team.name] = Array.new
        end

      end

      sponsored_teams[team_sponsor.team.name].push(team_sponsor)
    end
    sponsored_teams.sort
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teams_sponsor
      @teams_sponsor = TeamsSponsor.find(params[:id])
    end

    def set_univeral_params
      @teamsByDivision = get_all_teams_by_division
      @sponsors = Sponsor.where(:is_active => true) 
      @seasons = Season.all
      if @team_sponsor && @team_sponsor.team_id
        @selected_season = @team_sponsor.team.division.season_id
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teams_sponsor_params
      params.require(:teams_sponsor).permit(:team_id, :sponsor_id, :is_active, :link_id)
    end
end
