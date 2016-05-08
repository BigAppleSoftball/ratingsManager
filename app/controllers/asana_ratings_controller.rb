class AsanaRatingsController < ApplicationController
  before_action :set_asana_rating, only: [:show, :edit, :update, :destroy]
  include AsanaRatingsHelper
  # GET /asana_ratings
  # GET /asana_ratings.json
  def index
    @asana_ratings = AsanaRating.eager_load(:profile).order('profiles.last_name').all
  end

  def index_by_division
    division_id = params[:divisionId]
    @division = Division.find(division_id)
    # get all the teams in the division
    @teams = Team.includes(:rosters => {:profile => :asana_ratings}).where(:division_id => @division.id).order('teams.name ASC').order('profiles.last_name')
    # get all the players on the teams in the division

  end

  # GET /asana_ratings/1
  # GET /asana_ratings/1.json
  def show
    if @asana_rating.approved_profile_id.present?
      @approved_profile = Profile.find(@asana_rating.approved_profile_id)
    end
    @questions = get_questions
  end

  # GET /asana_ratings/new
  def new
    @asana_rating = AsanaRating.new
  end

  # GET /asana_ratings/1/edit
  def edit
    @questions = get_questions
  end

  def new_for_profile
    @profile = Profile.find(params[:profile_id])
    @asana_rating = AsanaRating.new
    @asana_rating[:profile_id] = @profile.id
    @questions = get_questions
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

  def get_questions
    questions = Hash.new
    questions[:throwing] = get_throwing_questions
    questions[:fielding] = get_fielding_questions
    questions[:batting] = get_batting_questions
    questions[:running] = get_running_questions
    questions[:fundamentals] = get_fundamental_questions
    questions[:experience] = get_experience_questions
    questions
  end

  def get_throwing_questions
    questions = Array.new
    questions.push(create_question(question_1, :rating_1))
    questions.push(create_question(question_2, :rating_2))
    questions.push(create_question(question_3, :rating_3))
    questions.push(create_question(question_4, :rating_4))
    questions
  end

  def get_fielding_questions
    questions = Array.new
    questions.push(create_question(question_5, :rating_5))
    questions.push(create_question(question_6, :rating_6))
    questions.push(create_question(question_7, :rating_7))
    questions.push(create_question(question_8, :rating_8))
    questions.push(create_question(question_9, :rating_9))
    questions.push(create_question(question_10, :rating_10))
    questions
  end

  def get_batting_questions
    questions = Array.new
    questions.push(create_question(question_11, :rating_11))
    questions.push(create_question(question_12, :rating_12))
    questions.push(create_question(question_13, :rating_13))
    questions.push(create_question(question_14, :rating_14))
    questions.push(create_question(question_15, :rating_15))
    questions.push(create_question(question_16, :rating_16))
    questions
  end

  def get_running_questions
    questions = Array.new
    questions.push(create_question(question_17, :rating_17))
    questions.push(create_question(question_18, :rating_18))
    questions.push(create_question(question_19, :rating_19))
    questions
  end

  def get_fundamental_questions
    questions = Array.new
    questions.push(create_question(question_20, :rating_20))
    questions
  end

  def get_experience_questions
    questions = Array.new
    questions.push(create_question(question_21, :rating_21, [['0 - No', 0], ['5 - Won Last Year', 5], ['10 - Won Past 2 Years', 10]]))
    questions.push(create_question(question_22, :rating_22, [['0 - No', 0], ['5 - Yes', 5]]))
    questions
  end

  def create_question(question, rating, options = ratings_options)
    q = Hash.new
    q[:question] = question
    q[:rating] = rating
    q[:options] = options
    q
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
