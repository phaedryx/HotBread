class User < ActiveRecord::Base
  has_many :authentications
  has_many :positions
  has_many :roles
  has_many :meetings, through: :roles

  validates :email, presence: true

  def self.find_with_id(id)
    where("id = ?", id).first
  end

  def self.find_with_email(email)
    where("email = ?", email).first
  end

  def self.find_with_auth(auth)
    where("email = ?", auth[:email]).first
  end

  def self.create_with_auth(auth)
    create(name: auth[:name], email: auth[:email], phone: auth[:phone])
  end

  def self.find_or_create_with_auth(auth)
    find_with_auth(auth) || create_with_auth(auth)
  end
end
