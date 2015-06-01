class ProfileMailer < ApplicationMailer

  def reset(profile)
    @profile = profile
    mail to: profile.email, subject: "[BASL Manager] Password Reset Request"
  end

  def welcome(profile)
    @profile = profile
    mail to:profile.email, subject: "Welcome to BASL Manager!"
  end

end