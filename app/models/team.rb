class Team < ActiveRecord::Base
  belongs_to :division, :foreign_key => :division_id

  has_many :sponsors, :through => :teams_sponsor,:primary_key => :sponsor_id, :foreign_key => :sponsor_id
  has_many :teams_sponsor,:primary_key => :sponsor_id, :foreign_key => :sponsor_id
end
