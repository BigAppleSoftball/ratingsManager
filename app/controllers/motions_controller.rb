class MotionsController < ApplicationController
  before_action :set_motion, only: [:show, :edit, :update, :destroy, :add_options]
  before_filter :only_for_admin, only: [:destroy, :new, :edit, :update, :add_new_option]

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

  def add_options

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_motion
      @motion = Motion.find(params[:id])
      @options = MotionOption.where(:motion_id => params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def motion_params
      params.require(:motion).permit(:title, :description, :is_active, :is_anonymous)
    end
end
