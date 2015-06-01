class SessionsController < ApplicationController
  def new
  end

  def create
    profile= Profile.find_by_email(params[:session][:email].downcase)
    if profile && profile.remember_token.blank?
      flash[:notice] = "First time signing into BASL Manager? Please Reset Your Password to get started." 
      redirect_to new_password_reset_path
    elsif profile && profile.authenticate(params[:session][:password])
      flash[:success] = "You have signed in successfully!" 
      # Sign the user in and redirect to the user's show page.
      sign_in(profile, false)
      current_teams = Array.new
      current_divisions = Array.new
      # if the user reps a division redirect to the division
      division_rep = BoardMember.eager_load(:division).where(:profile_id => profile.id).where(:is_division_rep => true).first
      if division_rep.present?
        current_divisions.push(division_rep.division)
      else # if the profile is connected to a current team redirect them to the team page
        roster_team_ids = Roster.where(:profile_id => profile.id).pluck(:team_id) 

        current_season = Season.eager_load(:divisions => :teams).where(:is_active => true).first
        
        current_season.divisions.each do |division|
          division.teams.each do |team|
            if (roster_team_ids.include?(team.id))
              current_teams.push(team)
            end
          end
        end
      end
      
      

      if current_divisions.length > 0
        current_division = current_divisions.first
        redirect_to division_path(current_division)
      elsif current_teams.length > 0
        current_team = current_teams.first
        redirect_to team_path(current_team)
      else
        redirect_to root_path
      end
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
