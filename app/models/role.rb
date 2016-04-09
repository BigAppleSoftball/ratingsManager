class Role < ActiveRecord::Base
  has_many :permissions, :through => :roles_permission
  has_many :roles_permission, dependent: :destroy

  has_many :profiles, :through => :profile_roles
  has_many :profile_roles, dependent: :destroy
end
