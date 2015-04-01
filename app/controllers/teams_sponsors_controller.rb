class TeamsSponsorsController < ApplicationController
  before_action :set_teams_sponsor, only: [:show, :edit, :update, :destroy]
  before_filter :only_for_admin, only: [:edit, :update, :destroy, :new]

  # GET /teams_sponsors
  # GET /teams_sponsors.json
  def index
    @teams_sponsors = TeamsSponsor.all
  end

  # GET /teams_sponsors/1
  # GET /teams_sponsors/1.json
  def show
  end

  # GET /teams_sponsors/new
  def new
    @teams_sponsor = TeamsSponsor.new
  end

  # GET /teams_sponsors/1/edit
  def edit
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
      format.html { redirect_to teams_sponsors_url, notice: 'Teams sponsor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teams_sponsor
      @teams_sponsor = TeamsSponsor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teams_sponsor_params
      params.require(:teams_sponsor).permit(:team_id, :sponsor_id, :is_active, :link_id)
    end
end
