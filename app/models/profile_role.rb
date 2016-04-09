class ProfileRole < ActiveRecord::Base
  belongs_to :profile
  belongs_to :role
end
