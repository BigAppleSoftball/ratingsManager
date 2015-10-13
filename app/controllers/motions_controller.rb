class MotionsController < ApplicationController
  before_action :set_motion, only: [:show, :edit, :update, :destroy, :options, :eligible]
  before_filter :only_for_admin, only: [:destroy, :new, :edit, :update, :options, :add_new_option]

  # GET /motions
  # GET /motions.json
  def index
    # TODO
    ## for admins - all Motions
    ## for Reps - All Active Motions
    ## For Users - Only show for reps, and for managers and Reps of their teams that have active motions
    @motions = Motion.all
  end

  # GET /motions/1
  # GET /motions/1.json
  def show
  end

  # GET /motions/new
  def new
    @motion = Motion.new
  end

  # GET /motions/1/edit
  def edit
  end

  # POST /motions
  # POST /motions.json
  def create
    @motion = Motion.new(motion_params)

    respond_to do |format|
      if @motion.save
        format.html { redirect_to @motion, notice: 'Motion was successfully created.' }
        format.json { render :show, status: :created, location: @motion }
      else
        format.html { render :new }
        format.json { render json: @motion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /motions/1
  # PATCH/PUT /motions/1.json
  def update
    respond_to do |format|
      if @motion.update(motion_params)
        format.html { redirect_to @motion, notice: 'Motion was successfully updated.' }
        format.json { render :show, status: :ok, location: @motion }
      else
        format.html { render :edit }
        format.json { render json: @motion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /motions/1
  # DELETE /motions/1.json
  def destroy
    @motion.destroy
    respond_to do |format|
      format.html { redirect_to motions_url, notice: 'Motion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def options
  end

  def add_new_option
    results = Hash.new
    @motion_option = MotionOption.new
    @motion_option[:motion_id] = params[:id]
    @motion_option[:title] = params[:title]
    if @motion_option.valid?
      @motion_option.save
      results[:success] = true
      results[:option] = @motion_option
      results[:html] = render_to_string(:template => "motions/_option_row.haml", :locals => {:option => @motion_option})
      # todo render the template of the motion option
    else
      results[:fail] = @motion_option.errors
    end
    respond_to do |format|
      format.json {
        render json: results
      }
    end

  end

  def delete_option
    results = Hash.new
    motion_option = MotionOption.find(params[:option_id])
    if (motion_option)
      results[:success] = true
      results[:option_id] = motion_option.id
      motion_option.destroy
    else
      results[:fail] = true
      results[:message] = 'Option not found, try again'
    end
    respond_to do |format|
      format.json {
        render json: results
      }
    end
  end

  #
  # Shows the list of eligible teams
  def eligible
    @seasons = Season.all
    @default_season = @seasons.last
    @default_divisions = Division.eager_load(:teams).where(:season_id => @default_season.id)
  end

  #
  # Gets the list of division/teams to select
  # from a season_id
  #
  def get_division_checklist
    divisions = Division.eager_load(:teams).where(:season_id => params[:season_id])
    results = Hash.new
    if divisions
      results[:success] = true
      results[:html] = render_to_string(:template => "motions/_division_teams_list.haml", :locals => {:divisions => divisions})
    else
      result[:fail] = true
    end
    respond_to do |format|
      format.json {
        render json: results
      }
    end
  end

  def save_eligible_teams
    @motion = Motion.find(params[:id])
    team_ids = params[:team_ids]
    if @motion
      team_ids.keys.each do |team_id|
        motionTeam = MotionTeam.create
        motionTeam.team_id = team_id
        motionTeam.motion_id = @motion.id
        motionTeam.save!
      end
      respond_to do |format|
        if @motion.save
          format.html { redirect_to @motion, notice: 'Eligible Teams were successfully updated.' }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_motion
      @motion = Motion.eager_load(:motion_options, :teams).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def motion_params
      params.require(:motion).permit(:title, :description, :is_active, :is_anonymous)
    end
end
