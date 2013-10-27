class Authentication < ActiveRecord::Base
  belongs_to :user

  validates :provider, :uid, :user_id, presence: true
  validates :uid, uniqueness: {scope: :provider}

  def self.find_with_uid_and_provider(uid, provider)
    where("uid = ? AND provider = ?", uid, provider).first
  end

  def self.find_with_auth(auth)
    find_with_uid_and_provider(auth[:uid], auth[:provider])
  end

  def self.create_with_auth(auth, user = nil)
    user ||= User.find_or_create_with_auth(auth)
    create(user: user, uid: auth[:uid], provider: auth[:provider])
  end

  def self.find_or_create_with_auth(auth)
    find_with_auth(auth) || create_with_auth(auth)
  end
end
