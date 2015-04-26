class RostersController < ApplicationController
  before_action :set_roster, only: [:show, :edit, :update, :destroy]

  # GET /rosters
  # GET /rosters.json
  def index
    @rosters = Roster.all
  end

  # GET /rosters/1
  # GET /rosters/1.json
  def show
  end

  # GET /rosters/new
  def new
    @roster = Roster.new
  end

  # GET /rosters/1/edit
  def edit
  end

  # POST /rosters
  # POST /rosters.json
  def create
    @roster = Roster.new(roster_params)

    respond_to do |format|
      if @roster.save
        format.html { redirect_to @roster, notice: 'Roster was successfully created.' }
        format.json { render :show, status: :created, location: @roster }
      else
        format.html { render :new }
        format.json { render json: @roster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rosters/1
  # PATCH/PUT /rosters/1.json
  def update
    respond_to do |format|
      if @roster.update(roster_params)
        format.html { redirect_to @roster, notice: 'Roster was successfully updated.' }
        format.json { render :show, status: :ok, location: @roster }
      else
        format.html { render :edit }
        format.json { render json: @roster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rosters/1
  # DELETE /rosters/1.json
  def destroy
    @roster.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Roster Updated.' }
      format.json { head :no_content }
    end
  end

  # Add a profile to a roster
  def add_player_to_roster
    response = Hash.new
    profileId = params[:profile_id]
    teamId = params[:team_id]
    profile = Profile.find_by_id(profileId)
    roster = Roster.new(
      :team_id => teamId,
      :profile_id => profileId
      )
    if roster.valid?
      roster.save
      response[:success] = true
      response[:profile_html] = render_to_string "teams/_roster_profile.haml", :layout => false, :locals => { :roster => roster}
    else
      response[:errors] = roster.errors.full_messages
    end
    respond_to do |format|
      format.json { render :json=> response}
    end
  end

  #
  # Sets or removed team manager or team rep depending on the parameters sent
  #
  def update_permissions
    response = Hash.new

    # use the params to determine what to sent the roster value to
    if (!params[:roster_id].nil?)
      roster = Roster.find_by( :id => params[:roster_id].to_i)
      if (params[:set_manager])
        roster[:is_manager] = true
      elsif(params[:set_rep])
        roster[:is_rep] = true
      elsif(params[:remove_rep])
        roster[:is_rep] = false
      elsif(params[:remove_manager])
        roster[:is_manager] = false
      end

      # make sure we are saving a valid roster or throw an error back to the interface
      if roster.valid?
        response[:success] = "Success! Roster Saved!"
        roster.save
        response[:html] = render_to_string "teams/_roster_profile.haml", :layout => false, :locals => { :roster => roster}
      else
        response[:error] = "Error! Could not save Roster."
      end
    else
      response[:error] = "Error! No Roster given"
    end

    respond_to do |format|
      format.json { render :json=> response}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roster
      @roster = Roster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def roster_params
      params.require(:roster).permit(:team_id, :profile_id, :date_created, :date_updated, :is_approved, :is_player, :is_rep, :is_manager, :is_active, :is_confirmed)
    end
end
