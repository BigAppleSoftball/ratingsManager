module SessionsHelper

  def sign_in(profile)
    remember_token = Profile.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    profile.update_attribute(:remember_token, Profile.encrypt(remember_token))
    self.current_profile = profile
  end

  def current_profile=(profile)
    @current_profile = profile
  end

   def current_profile
    remember_token = Profile.encrypt(cookies[:remember_token])
    @current_user ||= Profile.find_by_remember_token(remember_token)
  end

  def current_user
    current_profile
  end

  def signed_in?
    !current_profile.nil?
  end

  #def is_admin?
  #  signed_in? && current_user.permission == 2
  #end

  #def is_manager?
  #  teamsManaged.size > 0
  #end

  #def is_division_rep?
  #  divisionRep = DivisionRep.where(  :user_id => self.current_user.id)
  #  signed_in? && !divisionRep.empty?
  #end

  #def get_reps_division
  #  DivisionRep.where(  :user_id => self.current_user.id)
  #end

  #def is_division_rep(division)
  #  divisionRep = DivisionRep.where(  :user_id => self.current_user.id)
  #end

  #def teamsManaged
  #  teams =  TeamManager.where(:user_id => current_user.id)
  #end

  def sign_out
    self.current_profile = nil
    cookies.delete(:remember_token)
  end

  def current_profile
    remember_token = Profile.encrypt(cookies[:remember_token])
    @current_user ||= Profile.find_by_remember_token(remember_token)
  end

  def current_profile?(profile)
    profile == current_profile
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end


end