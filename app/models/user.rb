class User < ActiveRecord::Base
  # using a positions mask instead of separate models because the
  # positions are the same and don't change
  class PositionError < StandardError; end
  POSITIONS = [
    "Member",
    "President",
    "Vice President Education",
    "Vice President Membership",
    "Vice President Public Relations",
    "Secretary",
    "Treasurer",
    "Sergeant at Arms",
    "Webmaster"
  ]

  has_many :authentications
  has_many :roles
  has_many :meetings, through: :roles

  validates :email, presence: true

  def admin?
    has_position?("President") || has_position?("Webmaster")
  end

  # don't delete users unless you absolutely must
  alias_method :forced_destroy, :destroy
  def destroy
    update_attribute(:deleted_at, Time.zone.now)
  end

  def positions=(positions)
    invalid_positions = positions - POSITIONS
    raise PositionError.new("can't assign invalid positions: #{invalid_positions.join(', ')}") unless invalid_positions.empty?
    self.positions_mask = (positions & POSITIONS).map { |r| bitmask_index(r) }.sum
  end

  def positions
    POSITIONS.reject { |r| ((positions_mask || 0) & bitmask_index(r)).zero? }
  end

  def grant_position(position)
    raise PositionError.new("can't grant an invalid position") unless User.valid_position?(position)
    return false if has_position? position
    self.positions_mask += bitmask_index(position)
    true
  end

  def revoke_position(position)
    raise PositionError.new("can't revoke an invalid position") unless User.valid_position?(position)
    return false unless has_position? position
    self.positions_mask -= bitmask_index(position)
    true
  end

  def has_position?(position)
    positions.include? position
  end

  def self.valid_position?(position)
    POSITIONS.include? position
  end

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

private
  def bitmask_index(position)
    2**POSITIONS.index(position)
  end
end
