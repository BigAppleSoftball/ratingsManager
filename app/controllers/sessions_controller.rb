class SessionsController < ApplicationController
  def new
  end

  def create
    profile= Profile.find_by_email(params[:session][:email].downcase)
    if profile && profile.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in profile
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
