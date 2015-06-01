  # Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class ProfileMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://localhost:3000/rails/mailers/profile_mailer/reset
  def reset
    profile = Profile.first
    profile.reset_token = profile.new_token
    ProfileMailer.reset(profile)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/profile_mailer/welcome
  def welcome
    profile = Profile.first
    profile.reset_token = profile.new_token
    ProfileMailer.welcome(profile)
  end
end