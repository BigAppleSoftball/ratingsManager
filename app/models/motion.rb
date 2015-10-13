class Motion < ActiveRecord::Base
  has_many :motion_options
  has_many :teams, :through => :motion_teams
  has_many :motion_teams, dependent: :destroy
end
