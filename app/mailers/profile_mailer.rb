class ProfileMailer < ApplicationMailer

  def reset(profile)
    @profile = profile
    mail to: profile.email, subject: "[BASL-Manager] Password reset"
  end

end