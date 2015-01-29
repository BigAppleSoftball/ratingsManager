class Sponsor < ActiveRecord::Base
  has_many :teams, :through => :teams_sponsor,:primary_key => :sponsor_id, :foreign_key => :sponsor_id
  has_many :teams_sponsor, :primary_key => :sponsor_id, :foreign_key => :sponsor_id
end
