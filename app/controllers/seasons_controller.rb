
class SeasonsController < ApplicationController
  before_action :set_season, only: [:show, :edit, :update, :destroy]
  before_filter :only_for_admin, :clear_seasons_cache, only: [:edit, :update, :destroy, :new]

  # GET /seasons
  # GET /seasons.json
  def index
    @seasons = Season.all
  end

  # GET /seasons/1
  # GET /seasons/1.json
  def show
  end

  # GET /seasons/new
  def new
    @season = Season.new
  end

  # GET /seasons/1/edit
  def edit
  end

  # POST /seasons
  # POST /seasons.json
  def create
    @season = Season.new(season_params)

    respond_to do |format|
      if @season.save
        format.html { redirect_to @season, notice: 'Season was successfully created.' }
        format.json { render :show, status: :created, location: @season }
      else
        format.html { render :new }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seasons/1
  # PATCH/PUT /seasons/1.json
  def update
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to @season, notice: 'Season was successfully updated.' }
        format.json { render :show, status: :ok, location: @season }
      else
        format.html { render :edit }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.json
  def destroy
    @season.destroy
    respond_to do |format|
      format.html { redirect_to seasons_url, notice: 'Season was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_divisions_by_season
    response = Hash.new
    response_html = "<option></option>"
    seasonId = params[:season_id]
    divisions = Division.select('id, description').where(:season_id => seasonId)
    divisions.each do |division|
      response_html += "<option value='#{division.id}'>#{division.description}</option>"
    end
    response[:html] = response_html
    respond_to do |format|
      format.json { render :json=> response}
    end
  end

  #
  # Takes a season param and gets the games for that season
  #
  def games
    season_id = params[:seasonId].to_i
    @season = Season.find_by(:id => season_id)
    @games = Game.eager_load(:home_team => {:division =>:season}).where('divisions.season_id = ?', season_id).order(:start_time)
    #@games = Game.eager_load(:home_team => {:divisions => :season}, :away_team, :field).where('season.id = ?', season_id)
  end

  def show_nagaaa_ratings
    season_id = params[:id].to_i
    @season = Season.find(season_id)
    # get all the divisions in a season
    divisionIds = Division.where(:season_id => season_id, :is_coed => true).pluck(:id)

    # get all the teams in the division
    teams = Team.where(:division_id => divisionIds)
    values = get_rosters_and_ratings(teams)
    @team_names = values[:team_names]
    @valuesByTeamName =values[:by_name]

    respond_to do |format|
      # TODO (Paige) Support rendering Ratings 
      format.html { render layout: 'plain', template: 'divisions/ratings' }
      format.xls do
        response.headers['Content-Type'] = "application/vnd.ms-excel"
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@season.description}.xls\""
        render 'ratings.xls.haml'
      end
    end
  end

  def show_nagaaa_ratings
    show_season_ratings(params[:id].to_i)
  end

  def show_asana_ratings
    show_season_ratings(params[:id].to_i, true)
  end

  #
  # Takes values to render ratings for given Season
  #
  def show_season_ratings(season_id, isAsana = false)
    @season = Season.find(season_id)
    if isAsana
      # get all the Women's divisions in a season
      divisionIds = Division.where(:season_id => season_id, :is_coed => false).pluck(:id)
    else
      # get all the divisions in a season
      divisionIds = Division.where(:season_id => season_id, :is_coed => true).pluck(:id)
    end


    # get all the teams in the division
    teams = Team.where(:division_id => divisionIds)
    if isAsana 
      filename = 'ASANA_'
    else
      filename = 'NAGAAA_'
    end
    filename += @season.description
    show_ratings(teams, isAsana, filename)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season
      @season = Season.find(params[:id])
      @divisions = Division.eager_load(:teams).where(:season_id => @season.id).order('divisions.id, teams.win_perc DESC')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def season_params
      params.require(:season).permit(:league_id, :description, :date_start, :date_end, :is_active)
    end
end
