class TeamsSponsor < ActiveRecord::Base
  belongs_to :team
  belongs_to :sponsor
end
