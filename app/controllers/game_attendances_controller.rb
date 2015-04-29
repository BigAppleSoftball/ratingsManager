class GameAttendancesController < ApplicationController
  #before_action :set_game_attendance, only: [:show, :edit, :update, :destroy]

  # GET /game_attendances
  # GET /game_attendances.json
  #def index
  #  @game_attendances = GameAttendance.all
  #end

  # GET /game_attendances/1
  # GET /game_attendances/1.json
  #def show
  #end

  # GET /game_attendances/new
  #def new
  #  @game_attendance = GameAttendance.new
  #end

  # GET /game_attendances/1/edit
  #def edit
  #end

  # POST /game_attendances
  # POST /game_attendances.json
  #def create
  #  @game_attendance = GameAttendance.new(game_attendance_params)

  #  respond_to do |format|
  #    if @game_attendance.save
  #      format.html { redirect_to @game_attendance, notice: 'Game attendance was successfully created.' }
  #      format.json { render :show, status: :created, location: @game_attendance }
  #    else
  #      format.html { render :new }
  #      format.json { render json: @game_attendance.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end
  #
  def set_attendance
    response = Hash.new
    # see if the attendance relationship already exists
    gameAttendance = GameAttendance.where(:roster_id => params[:roster_id], :game_id => params[:game_id]).first

    if gameAttendance.nil?
      gameAttendance = GameAttendance.new({
        :roster_id => params[:roster_id],
        :game_id =>  params[:game_id]
      })
    end
    gameAttendance[:is_attending]=params[:is_attending]
    gameAttendance.save
    respond_to do |format|
      format.json { render :json=> response}
    end
  end

  # PATCH/PUT /game_attendances/1
  # PATCH/PUT /game_attendances/1.json
  def update
    respond_to do |format|
      if @game_attendance.update(game_attendance_params)
        format.html { redirect_to @game_attendance, notice: 'Game attendance was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_attendance }
      else
        format.html { render :edit }
        format.json { render json: @game_attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_attendances/1
  # DELETE /game_attendances/1.json
  def destroy
    @game_attendance.destroy
    respond_to do |format|
      format.html { redirect_to game_attendances_url, notice: 'Game attendance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_attendance
      @game_attendance = GameAttendance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_attendance_params
      params.require(:game_attendance).permit(:profile_id, :game_id, :is_attending)
    end
end
