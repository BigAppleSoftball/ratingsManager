class Profile < ActiveRecord::Base
  belongs_to :team
  has_one :hallof_famer
  has_many :rosters
  has_one :rating
  has_one :board_member
  has_one :committee
end
