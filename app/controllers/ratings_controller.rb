class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]
  before_filter :only_for_admin, only: [:destroy, :show_duplicates]
  include RatingsHelper
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
    @active_season = Season.includes(:divisions => {:teams => {:rosters => {:profile => {:rating => :profile}}}}).where(:is_active => true).last
    
    respond_to do |format|
      format.html
      format.csv
    end
  end

  #
  # Gets all the duplicate ratings and show them
  #
  def show_duplicates
    @duplicate_ratings = get_duplicates
  end

  def remove_duplicates
    ratings = Rating.all.order(:profile_id)
    profile_ids = ratings.pluck(:profile_id)
    duplicate_profile_ids = profile_ids.group_by {|e| e}.select { |k,v| v.size > 1}.keys
    ap duplicate_profile_ids
    @profile_ids = duplicate_profile_ids

    @profile_ids.each do |profile_id|
      duplicate_ratings = Rating.where(:profile_id => profile_id).order(:updated_at)
      duplicates_count = duplicate_ratings.size
      for x in 0..(duplicates_count - 2)
        duplicate_ratings[x].destroy
      end
    end

  end

  def get_duplicates
    ratings = Rating.all.order(:profile_id)
    profile_ids = ratings.pluck(:profile_id)
    duplicate_profile_ids = profile_ids.group_by {|e| e}.select { |k,v| v.size > 1}.keys
    duplicate_ratings = Rating.where(:profile_id => duplicate_profile_ids).order(:profile_id)

    duplicate_ratings
  end


  # GET /profiles/1
  # GET /profiles/1.json
  def show

  end

  def edit
    @questions = get_questions
  end

  def get_throwing_questions
    questions = Array.new
    questions.push(create_question(question_1, :rating_1))
    questions.push(create_question(question_2, :rating_2))
    questions.push(create_question(question_3, :rating_3))
    questions.push(create_question(question_4, :rating_4))
    questions.push(create_question(question_5, :rating_5))
    questions
  end

  def get_fielding_questions
    questions = Array.new
    questions.push(create_question(question_6, :rating_6))
    questions.push(create_question(question_7, :rating_7))
    questions.push(create_question(question_8, :rating_8))
    questions.push(create_question(question_9, :rating_9))
    questions.push(create_question(question_10, :rating_10))
    questions.push(create_question(question_11, :rating_11))
    questions.push(create_question(question_12, :rating_12))
    questions.push(create_question(question_13, :rating_13))
    questions.push(create_question(question_14, :rating_14))
    questions
  end

  def get_running_questions
    questions = Array.new
    questions.push(create_question(question_15, :rating_15))
    questions.push(create_question(question_16, :rating_16))
    questions.push(create_question(question_17, :rating_17))
    questions.push(create_question(question_18, :rating_18))
    questions
  end

  def get_hitting_questions
    questions = Array.new
    questions.push(create_question(question_19, :rating_19))
    questions.push(create_question(question_20, :rating_20))
    questions.push(create_question(question_21, :rating_21))
    questions.push(create_question(question_22, :rating_22))
    questions.push(create_question(question_23, :rating_23))
    questions.push(create_question(question_24, :rating_24))
    questions.push(create_question(question_25, :rating_25))
    questions.push(create_question(question_26, :rating_26))
    questions.push(create_question(question_27, :rating_27))
    questions
  end

  def get_questions
    questions = Hash.new
    questions[:throwing] = get_throwing_questions
    questions[:fielding] = get_fielding_questions
    questions[:running]  = get_running_questions
    questions[:hitting]  = get_hitting_questions
    questions
  end

  def create_question(question, rating, options = ratings_options)
    q = Hash.new
    q[:question] = set_question(question)
    q[:rating] = rating
    q[:options] = options
    q
  end

  def new_for_profile
    @profile = Profile.find(params[:profile_id])
    if @profile.present?
      @rating = Rating.new
      @rating[:profile_id] = @profile.id
      @questions = get_questions
      render 'edit'
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
      format.html { redirect_to :back, notice: 'Duplicate Rating was successfully Removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.eager_load(:profile).find(params[:id])

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:profile_id, :date_rated, :date_approved, :rated_by_profile_id, :approved_by_profile_id, :is_provisional, :is_approved, :is_active, :rating_1, :rating_2, :rating_3, :rating_4, :rating_5, :rating_6, :rating_7, :rating_8, :rating_9, :rating_10, :rating_11, :rating_12, :rating_13, :rating_14, :rating_15, :rating_16, :rating_17, :rating_18, :rating_19, :rating_20, :rating_21, :rating_22, :rating_23, :rating_24, :rating_25, :rating_26, :rating_27, :ng, :nr, :teamsnap_id)
    end
end
