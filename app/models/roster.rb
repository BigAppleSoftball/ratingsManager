class Roster < ActiveRecord::Base
  belongs_to :profile
  belongs_to :team
  has_many :game_attendances, dependent: :destroy

  # TODO make sure the team exists and the profile exists
  validates :profile_id, presence: true
  validates :team_id, presence: true
end
