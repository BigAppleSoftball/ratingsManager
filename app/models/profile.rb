class Profile < ActiveRecord::Base
  belongs_to :team
  has_many :rosters
end
