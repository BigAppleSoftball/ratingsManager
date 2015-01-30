class Profile < ActiveRecord::Base
  belongs_to :team
  has_many :rosters
  has_one :rating
end
