class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]
  skip_before_filter  :update_player

  #
  # From ajax updates player from a given id
  #
  def update_player
    response = Hash.new
    profile_id = params[:profileId].to_i
    ratings = params[:ratings]
    type = params[:type]
    response[:profile_id] = profile_id
    response[:ratings] = ratings
    response[:type] = type

    @rating = Rating.where(:profile_id => profile_id).order(:id).last
    if @rating.nil?
      puts "Rating not found on #{profile_id}"
      response.error = "Rating not found"
    else
      ratings.each do |key, value|
        @rating[key] = value.to_i
      end
      if (@rating.valid?)
        @rating.save
        response[:success] = true
        response[:rating_total] = @rating.total
      else
        response[:errors] = @rating.errors
      end
    end

    respond_to do |format|
      format.json { render json: response }
    end
  end

  #
  # Creates a new player and returns a json file on success
  #
  def new_player
    response = Hash.new
    profile_id = params[:profileId].to_i
    # make sure the rating doesn't already exist
    profile = Profile.find(profile_id)
    rating = Rating.find_by(:profile_id => profile_id)
    if profile.present?
      if rating.nil?
        rating = Rating.new
        rating.profile_id = profile_id
        if (rating.valid?)
          rating.save
          response[:profile_id] = profile_id
          response[:rating_total] = 0
          response[:ratings] = rating_to_type_json(rating)
          response[:success] = true
          response[:rating_row_html] = render_to_string "teams/ratings/_row.haml", :layout => false, :locals => { :profile => profile}
        else
          response[:errors] = @rating.errors
        end
      end
      response[:errors] = "No Profile Found"
    end
    respond_to do |format|
      format.json { render json: response }
    end
  end

  # GET /ratings
  # GET /ratings.json
  def index
    #@profile_ratings = Profile.all
    @active_season = Season.includes(:divisions => {:teams => {:rosters => {:profile => :rating}}}).where(:is_active => true).last

    
    respond_to do |format|
      format.html
      format.csv
    end
  end


  # POST /ratings
  # POST /ratings.json
  def create
    @rating = Rating.new(rating_params)

    respond_to do |format|
      if @rating.save
        format.html { redirect_to @rating, notice: 'Rating was successfully created.' }
        format.json { render :show, status: :created, location: @rating }
      else
        format.html { render :new }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  def update
    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to @rating, notice: 'Rating was successfully updated.' }
        format.json { render :show, status: :ok, location: @rating }
      else
        format.html { render :edit }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to ratings_url, notice: 'Rating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:profile_id, :date_rated, :date_approved, :rated_by_profile_id, :approved_by_profile_id, :is_provisional, :is_approved, :is_active, :rating_1, :rating_2, :rating_3, :rating_4, :rating_5, :rating_6, :rating_7, :rating_8, :rating_9, :rating_10, :rating_11, :rating_12, :rating_13, :rating_14, :rating_15, :rating_16, :rating_17, :rating_18, :rating_19, :rating_20, :rating_21, :rating_22, :rating_23, :rating_24, :rating_25, :rating_26, :rating_27, :ng, :nr, :teamsnap_id)
    end
end
