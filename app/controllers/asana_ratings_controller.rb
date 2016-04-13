class AsanaRatingsController < ApplicationController
  before_action :set_asana_rating, only: [:show, :edit, :update, :destroy]

  # GET /asana_ratings
  # GET /asana_ratings.json
  def index
    @asana_ratings = AsanaRating.all
  end

  # GET /asana_ratings/1
  # GET /asana_ratings/1.json
  def show
    @approved_profile = Profile.find(@asana_rating.approved_profile_id)
  end

  # GET /asana_ratings/new
  def new
    @asana_rating = AsanaRating.new
  end

  # GET /asana_ratings/1/edit
  def edit
  end

  def new_for_profile
    @profile = Profile.find(params[:profile_id])
    @asana_rating = AsanaRating.new
    @asana_rating[:profile_id] = @profile.id
  end

  # POST /asana_ratings
  # POST /asana_ratings.json
  def create
    @asana_rating = AsanaRating.new(asana_rating_params)

    respond_to do |format|
      if @asana_rating.save
        format.html { redirect_to @asana_rating, notice: 'Asana rating was successfully created.' }
        format.json { render :show, status: :created, location: @asana_rating }
      else
        format.html { render :new }
        format.json { render json: @asana_rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /asana_ratings/1
  # PATCH/PUT /asana_ratings/1.json
  def update
    respond_to do |format|
      if @asana_rating.update(asana_rating_params)
        format.html { redirect_to @asana_rating, notice: 'Asana rating was successfully updated.' }
        format.json { render :show, status: :ok, location: @asana_rating }
      else
        format.html { render :edit }
        format.json { render json: @asana_rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asana_ratings/1
  # DELETE /asana_ratings/1.json
  def destroy
    @asana_rating.destroy
    respond_to do |format|
      format.html { redirect_to asana_ratings_url, notice: 'Asana rating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asana_rating
      @asana_rating = AsanaRating.find(params[:id])
      @profile = Profile.find(@asana_rating[:profile_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asana_rating_params
      params.require(:asana_rating).permit(:profile_id, :is_approved, :approved_profile_id, :rating_1, :rating_2, :rating_3, :rating_4, :rating_5, :rating_6, :rating_7, :rating_8, :rating_9, :rating_10, :rating_11, :rating_12, :rating_13, :rating_14, :rating_15, :rating_16, :rating_17, :rating_18, :rating_19, :rating_20, :rating_21, :rating_22)
    end
end
