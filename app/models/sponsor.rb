class Sponsor < ActiveRecord::Base
  has_many :teams, :through => :teams_sponsor
  has_many :teams_sponsor, dependent: :destroy
end
