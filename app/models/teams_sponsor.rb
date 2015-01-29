class TeamsSponsor < ActiveRecord::Base
  belongs_to :team, :primary_key => :teamsnap_id
  belongs_to :sponsor, :primary_key => :sponsor_id, :foreign_key => :sponsor_id
end
