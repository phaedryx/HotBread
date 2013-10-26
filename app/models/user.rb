class User < ActiveRecord::Base
  has_many :positions
  has_many :roles
  has_many :meetings, through: :roles
end
