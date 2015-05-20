class PasswordResetsController < ApplicationController
  def new
  end

  def edit
    @profile = Profile.find_by(reset_token: params[:id])
  end

  def create
    @profile = Profile.find_by(email: params[:password_reset][:email].downcase)
    if @profile
      @profile.create_reset_digest
      @profile.send_password_reset_email
      flash[:notice] = "An email has been sent with password reset instructions please check your inbox"
      redirect_to root_url
    else
      flash[:error] = "Account with email address Not found, please try again"
      render 'new'
    end
  end

  def update
    @profile = Profile.find_by(email: params[:email].downcase)
    if password_blank?
      flash.now[:error] = "Password can't be blank"
      render 'edit'
    elsif @profile.update_attributes(profile_params)
      sign_in @profile
      flash[:success] = "Password has been reset."
      redirect_to @profile
    else
      render 'edit'
    end
  end


  private
    def profile_params
      params.require(:profile).permit(:password, :password_confirmation)
    end

    # Returns true if password is blank.
    def password_blank?
      params[:profile][:password].blank?
    end

end
