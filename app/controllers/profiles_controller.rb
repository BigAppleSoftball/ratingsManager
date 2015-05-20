class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_filter :only_for_admin, only: [:destroy, :merge, :run_merge]
  before_filter(:only => [:edit, :update]) { only_for_admin_or_current_user params[:id].to_i }
  before_filter :only_logged_in, only: [:show, :index]
  helper_method :sort_column, :sort_direction
  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 20,:page => params[:page])
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show

  end

  # GET /profiles/new
  def new
    @profile = Profile.new
    @is_signup = true
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    if params[:profile][:password].blank?
      params[:profile].delete(:password) 
      params[:profile].delete(:password_confirmation) 
    end
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #
  # Merges one profile into another (first profile will be destroyed)
  #
  def merge
    @profile = Profile.eager_load(:board_members, :committees, :rosters => {:team => {:division =>:season }}).find(params[:profile_id])
    @all_profiles = Profile.select('first_name, last_name, id').all
  end

  def run_merge
    response = Hash.new
    if (params[:profile1_id].to_i == params[:profile2_id] )
      response[:error] = "Cannot run merge on same profiles"
    else
      # get profile 1
      mergeProfile = Profile.eager_load(:rosters, :board_members, :committees, :rating).find(params[:profile1_id])
      # get profile2
      baseProfile = Profile.eager_load(:rating).find(params[:profile2_id])

      if (mergeProfile.present? && baseProfile.present?)
        # get all the fields we are looking to update
        
        # update all the rosters
        mergeProfile.rosters.each do |roster|
          roster.profile_id = baseProfile.id
          roster.save
        end
        # update all the board_committees
        mergeProfile.board_members.each do |member|
          member.profile_id = baseProfile.id
          member.save
        end

        mergeProfile.committees.each do |committee|
          committee.profile_id = baseProfile.id
          committee.save
        end

        #mergeProfile.hall_offamer.each do |famer|
        #  famer.profile_id = baseProfile.id
        #  famer.save
        #end
        
        #
        # only merge the ratings if the base profile doesn't have a rating
        if (baseProfile.rating.blank?)
          if mergeProfile.rating.present?
            mergeProfile.rating.profile_id = baseProfile.id
          end
        end

        #save the update to baseProfile
        baseProfile.save

        response[:success] = "Players merged!"
        response[:profile_link] = profile_url(baseProfile.id)
        # delete merge profile
        #mergeProfile.destroy
      else
        response[:error] = "Need Two Profiles to run a merge"
      end
    end
    respond_to do |format|
      format.json { render :json=> response }
    end
  end

  #
  # Gets a list of all players available for tournaments
  #
  def pickup_players
    @players = Profile.eager_load(:rating).where(:is_pickup_player => true).order('last_name')
  end

  #
  # Load just the profile details without a layout
  #
  def details
    response = Hash.new
    profile = Profile.eager_load(:board_members, :committees, :rosters => {:team => {:division =>:season }}).find(params[:profile_id])

    profile_details_html = render_to_string "_details.html.haml", :layout => false, :locals => { :profile => profile}
    response[:html] = profile_details_html
    respond_to do |format|
      format.json { render :json=> response}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.eager_load(:board_members, :committees, :rosters => {:team => {:division =>:season }}).find(params[:id])
      @board_members = BoardMember.where(:profile_id => params[:id])
      @committees = Committee.where(:profile_id => params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:profile_code, :first_name, :last_name, :email, :display_name, :player_number, :gender, :shirt_size, :address, :state, :zip, :phone, :position, :dob, :team_id, :long_image_url, :password, :password_confirmation, :is_admin, :permissions, :address2, :city, :is_pickup_player)
    end

    def sort_column
      Profile.column_names.include?(params[:sort]) ? params[:sort] : "last_name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
