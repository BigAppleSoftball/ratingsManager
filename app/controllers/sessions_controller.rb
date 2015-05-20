class SessionsController < ApplicationController
  def new
  end

  def create
    profile= Profile.find_by_email(params[:session][:email].downcase)
    if profile && profile.remember_token.blank?
      flash[:notice] = "First time signing into BASL Manager? Please Reset Your Password to get started." 
      redirect_to new_password_reset_path
    elsif profile && profile.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in profile
      redirect_to root_path
    else
      flash.now[:error] = "Invalid Login. Please Try again. \n Did you forget your password? <a href='#{new_password_reset_path}'>Reset Password</a>".html_safe
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
