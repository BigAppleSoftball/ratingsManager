class Roster < ActiveRecord::Base
  belongs_to :profile
  belongs_to :team

  # TODO make sure the team exists and the profile exists
  validates :profile_id, presence: true
  validates :team_id, presence: true
end
