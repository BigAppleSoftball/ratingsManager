class TeamsnapPayment < ActiveRecord::Base
  validates :teamsnap_player_id, presence: true,
              uniqueness: { case_sensitive: false }
end
