module SessionsHelper

  def sign_in(profile, is_impersonate = true)
    remember_token = Profile.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    profile.update_attribute(:remember_token, Profile.encrypt(remember_token))
    if !is_impersonate
      profile.update_attribute(:last_log_in, DateTime.now)
    end
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
    Rails.cache.fetch("current_profile2_#{cookies[:remember_token]}", :expires_in => 60.minutes) do
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
    false
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
  # checks to see if the division id is in the list of user division rep
  #
  def is_division_rep(division_id)
    if is_logged_in?
      ap current_profile.divisions.repped_list
      current_profile.divisions_repped_list.include?(division_id)
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
    false
    #is_logged_in? && (is_admin? || is_manager? || is_division_rep?)
  end

  #
  # check to see if the user is logged int
  #
  def is_logged_in?
    true
    #current_profile.present?
  end
  
  #
  # if given user is th logged in user
  #
  def is_current_user?(user_id)
    false
    #is_logged_in? && current_profile.id == user_id
  end


  def is_current_user_or_admin?(user_id)
    false
    #is_logged_in? && current_profile.id == user_id || is_admin?
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
  # Redirect pages if not team manager, team rep or division rep of this team
  #
  def only_team_manager_reps_or_division_reps(team_id) 
    team = Team.select('division_id').find(team_id.to_i)
    ap team.division_id
    if (!is_logged_in? && (!is_admin? || !is_team_manager?(team_id.to_i) || !is_division_rep?(team.division_id)))
      redirect_to :action =>'error_403', :controller => 'errors'
    end
  end

  #
  # Only for Admins or the current user
  #
  def only_for_admin_or_current_user(profile_id)
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

  ## Permissions Stuff
  #
  #
  # If the User Doesn't have the Permissions to view 
  #
  def has_permissions_redirect(pid)
    if !has_permissions?(pid)
      redirect_to :action =>'error_403', :controller => 'errors'
    end
  end

  def has_permissions?(pid)
    user_permissions = get_current_user_permissions
    return user_permissions.include?(pid)
  end

  #
  # TODO(Paige) Store this as a cookie or something
  # Shouldn't get this every page load
  #
  def get_current_user_permissions
    user_permissions = Array.new
    # Get All the Users Roles
    proles = ProfileRole.eager_load(:role => :roles_permission).where(:profile_id => current_user.id)
    proles.each do |pr|
      pr.role.roles_permission.each do |rp|
        if !(user_permissions.include?(rp.permission_id)) 
          user_permissions.push(rp.permission_id)
        end
      end
    end
    user_permissions
  end


end