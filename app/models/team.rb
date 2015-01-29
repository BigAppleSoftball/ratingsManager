class Team < ActiveRecord::Base
  belongs_to :division

  has_many :sponsors, :through => :teams_sponsor
  has_many :profiles
  has_many :rosters
  has_many :teams_sponsor
end
