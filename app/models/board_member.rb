class BoardMember < ActiveRecord::Base
  belongs_to :profile
  belongs_to :division
end
