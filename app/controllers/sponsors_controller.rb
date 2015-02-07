class SponsorsController < ApplicationController
  before_action :set_sponsor, only: [:show, :edit, :update, :destroy]

  before_filter :only_for_admin, only: [:edit, :update, :destroy]
  after_action :set_access_control_headers

  # GET /sponsors
  # GET /sponsors.json
  def index
    @sponsors = Sponsor.order('name ASC').all
  end

  # GET /sponsors/1
  # GET /sponsors/1.json
  def show
    teams_sponsors = TeamsSponsor.where(:sponsor_id => params[:id])
    @teamSponsors = Array.new
    teams_sponsors.each do |team_sponsor|
      sponsors = Sponsor.where(:sponsor_id => team_sponsor[:sponsor_id])
      @teamSponsors.push(team_sponsor)
    end
    @teamSponsors
  end

  # GET /sponsors/new
  def new
    @sponsor = Sponsor.new
  end

  # GET /sponsors/1/edit
  def edit
  end

  def league_sponsors
    sponsors = Sponsor.where(:show_carousel => true)
    respond_to do |format|
       format.json { render :json => sponsors }
     end
  end

  # POST /sponsors
  # POST /sponsors.json
  def create
    @sponsor = Sponsor.new(sponsor_params)

    respond_to do |format|
      if @sponsor.save
        format.html { redirect_to @sponsor, notice: 'Sponsor was successfully created.' }
        format.json { render :show, status: :created, location: @sponsor }
      else
        format.html { render :new }
        format.json { render json: @sponsor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sponsors/1
  # PATCH/PUT /sponsors/1.json
  def update
    respond_to do |format|
      if @sponsor.update(sponsor_params)
        format.html { redirect_to @sponsor, notice: 'Sponsor was successfully updated.' }
        format.json { render :show, status: :ok, location: @sponsor }
      else
        format.html { render :edit }
        format.json { render json: @sponsor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sponsors/1
  # DELETE /sponsors/1.json
  def destroy
    @sponsor.destroy
    respond_to do |format|
      format.html { redirect_to sponsors_url, notice: 'Sponsor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_access_control_headers
   headers['Access-Control-Allow-Origin'] = "*"
  end

  def all_sponsors
    @sponsors = Sponsor.where(:is_active => true)
    render layout: false
  end

  def sponsor_carousel
    @sponsors = Sponsor.where(:show_carousel => true)
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sponsor
      @sponsor = Sponsor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sponsor_params
      params.require(:sponsor).permit(:Sponsor_id, :name, :url, :email, :phone, :details, :date_created, :date_updated, :created_user_id, :updated_user_id, :is_active, :is_league, :show_carousel, :logo_url)
    end
end
