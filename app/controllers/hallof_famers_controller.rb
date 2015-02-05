class HallofFamersController < ApplicationController
  before_action :set_hallof_famer, only: [:show, :edit, :update, :destroy]
  before_filter :only_for_admin

  # GET /hallof_famers
  # GET /hallof_famers.json
  def index
    @hallof_famers = HallofFamer.all
  end

  # GET /hallof_famers/1
  # GET /hallof_famers/1.json
  def show
  end

  # GET /hallof_famers/new
  def new
    @hallof_famer = HallofFamer.new
  end

  # GET /hallof_famers/1/edit
  def edit
  end

  # POST /hallof_famers
  # POST /hallof_famers.json
  def create
    @hallof_famer = HallofFamer.new(hallof_famer_params)

    respond_to do |format|
      if @hallof_famer.save
        format.html { redirect_to @hallof_famer, notice: 'Hallof famer was successfully created.' }
        format.json { render :show, status: :created, location: @hallof_famer }
      else
        format.html { render :new }
        format.json { render json: @hallof_famer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hallof_famers/1
  # PATCH/PUT /hallof_famers/1.json
  def update
    respond_to do |format|
      if @hallof_famer.update(hallof_famer_params)
        format.html { redirect_to @hallof_famer, notice: 'Hallof famer was successfully updated.' }
        format.json { render :show, status: :ok, location: @hallof_famer }
      else
        format.html { render :edit }
        format.json { render json: @hallof_famer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hallof_famers/1
  # DELETE /hallof_famers/1.json
  def destroy
    @hallof_famer.destroy
    respond_to do |format|
      format.html { redirect_to hallof_famers_url, notice: 'Hallof famer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hallof_famer
      @hallof_famer = HallofFamer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hallof_famer_params
      params.require(:hallof_famer).permit(:profile_id, :date_inducted, :is_active, :is_inducted)
    end
end
