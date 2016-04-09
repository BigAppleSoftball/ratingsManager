class Permission < ActiveRecord::Base
  has_many :roles, :through => :roles_permission
  has_many :roles_permission, dependent: :destroy
end
