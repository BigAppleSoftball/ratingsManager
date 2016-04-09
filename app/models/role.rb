class Role < ActiveRecord::Base
  has_many :permissions, :through => :roles_permission
  has_many :roles_permission, dependent: :destroy
end
