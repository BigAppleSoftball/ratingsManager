module SessionsHelper

  def sign_in(profile)
    remember_token = Profile.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    profile.update_attribute(:remember_token, Profile.encrypt(remember_token))
    self.current_profile = profile
    session[:current_user_id] = profile
  end

  def current_profile=(profile)
    @current_profile = profile
  end

   def current_profile
    if @current_user.nil?
      @current_user ||= get_current_profile
    end
    @current_user
  end

  def get_current_profile
    Rails.cache.fetch("current_profile_#{cookies[:remember_token]}", :expires_in => 60.minutes) do
      remember_token = Profile.encrypt(cookies[:remember_token])
      Profile.eager_load(:rosters => {:team => {:division =>:season }}).find_by_remember_token(remember_token)
    end
  end
 
  def current_user
    current_profile
  end

  #
  # Checks to see if the current user is the given profile id
  #
  def is_current_user?(profile_id)
    is_logged_in? && (is_profile_id == current_profile.id)
  end

  def signed_in?
    session[:current_user_id].nil? && !current_profile.nil?
  end

  def current_profile?(profile)
    profile == current_profile
  end



  #--------------------------------------------
  #
  #   Permissions
  #
  #--------------------------------------------

  #
  # checks if user is a site adminstrator
  #
  def is_admin?
    is_logged_in? && current_user.is_admin
  end

  #
  # Checks to see if the user is an admin
  #
  def is_manager?
    if is_logged_in?
      roster = Roster.where(:profile_id => current_profile.id, :is_manager => true)
      current_profile && roster.length > 0
    else
      false
    end
  end

  #
  # checks to see if the team id is in the list of user ids
  #
  def is_team_manager?(team_id)
    if is_logged_in?
      current_profile.teams_managed_list.include?(team_id)
    else
      false
    end
  end

  #
  # Checks to see if the user is a division rep
  #
  def is_division_rep?(division_id = nil)
    if is_logged_in?
      if !division_id.nil?
        current_profile.divisions_repped_list.include?(division_id)
      else
        !current_profile.divisions_repped.empty?
      end
    else
      false
    end
  end

  #
  # Checks to see if the user is an adminstrative user (admin, rep or manager)
  #
  def is_admin_user?
    is_logged_in? && (is_admin? || is_manager? || is_division_rep?)
  end

  #
  # check to see if the user is logged int
  #
  def is_logged_in?
    current_profile.present?
  end
  
  #
  # if given user is th logged in user
  #
  def is_current_user?(user_id)
    is_logged_in? && current_profile.id == user_id
  end


  def is_current_user_or_admin?(user_id)
    ap user_id
    ap current_profile.id
    is_logged_in? && current_profile.id == user_id || is_admin?
  end

  #
  # redirect for pages only meant for site adminstrators
  #
  def only_for_admin
    if (!is_admin?)
      redirect_to :action =>'error_403', :controller => 'errors'
    end
  end

  #
  # Redirect for pages only meant for an admin user
  #
  def only_for_admin_user
    if !(is_admin_user?)
      redirect_to :action =>'error_403', :controller => 'errors'
    end
  end

  #
  # Redirect for pages only meant for a manager (admins automatically see everything)
  #
  def only_team_manager(team_id)
    if (!is_admin? && !is_team_manager?(team_id.to_i))
      redirect_to :action =>'error_403', :controller => 'errors'
    end
  end


  def only_team_in_active_season(team_id)
    team = Team.find_by_id(team_id)
    if (!team.division.season.is_editable_season?)
      inactive_season
    end
  end

  #
  # redirect for pages meant for a division Rep (admins automatically see everything)
  #
  def only_division_rep(division_id)
    if (!is_admin? && !is_division_rep?(division_id.to_i))
      redirect_to :action =>'error_403', :controller => 'errors'
    end
  end

  def only_logged_in
    if (!is_logged_in?)
      redirect_to :action =>'error_403', :controller => 'errors'
    end
  end

  #
  # Only for Admins or the current user
  #
  def only_for_admin_or_current_user(profile_id)
    ap profile_id
    if (!is_current_user_or_admin?(profile_id))
      redirect_to :action =>'error_403', :controller => 'errors'
    end
  end

  def sign_out
    self.current_profile = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end


end