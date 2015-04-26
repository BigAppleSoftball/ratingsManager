class ParksController < ApplicationController
  before_action :set_park, only: [:show, :edit, :update, :destroy]
  before_filter :only_for_admin, only: [:edit, :update, :destroy, :new]

  # GET /fields
  # GET /fields.json
  def index
    @parks = Park.all
    parksClosedCount = @parks.where(:status => 2).length
    parksOpenCount = @parks.where(:status => 0).length

    @allParksClosed = parksClosedCount == @parks.length
    @allParksOpen = parksOpenCount == @parks.length
    @parksPartial = (!@allParksClosed && !@allParksOpen)
  end

  # GET /fields/1
  # GET /fields/1.json
  def show
  end

  # GET /fields/new
  def new
    @park = Park.new
  end

  # GET /fields/1/edit
  def edit
  end

  # POST /fields
  # POST /fields.json
  def create
    @park = Park.new(park_params)

    respond_to do |format|
      if @park.save
        format.html { redirect_to @park, notice: 'Field was successfully created.' }
        format.json { render :show, status: :created, location: @park }
      else
        format.html { render :new }
        format.json { render json: @park.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fields/1
  # PATCH/PUT /fields/1.json
  def update
    respond_to do |format|
      if @park.update(park_params)
        format.html { redirect_to @park, notice: 'Park was successfully updated.' }
        format.json { render :show, status: :ok, location: @field }
      else
        format.html { render :edit }
        format.json { render json: @park.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fields/1
  # DELETE /fields/1.json
  def destroy
    @park.destroy
    respond_to do |format|
      format.html { redirect_to parks_url, notice: 'Field was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #
  # Updates all parks to a given status
  #
  def set_all
    status_num = params[:statusNum]
    set_to_status = status_num.to_i
    results = Hash.new
    Park.all.update_all(:status => set_to_status)
    results[:success] = true
    results[:status] = get_park_statuses[set_to_status]
    render :json => results
  end

  def show_map
    @parks = Park.where.not(:lat => nil).order('name ASC')
    render layout: false
  end

  def get_park_json
    parks = Park.where.not(:lat => nil).to_json
    render :json => parks
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_park
      @park = Park.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def park_params
      params.require(:park).permit(:status, :name, :url, :google_map_url, :address, :city, :state, :zip, :by_car, :by_bus, :by_train, :parking, :is_active, :long, :lat)\
    end
end
