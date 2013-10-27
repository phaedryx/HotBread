require "test_helper"

describe User do
  let(:valid_params) do
    {name: "Belisarius Jones", email: "bj@example.com", phone: "801-555-5555"}
  end

  let(:justinian_auth_hash) do
    {name: "Justinian Jones", email: "jj@example.com", phone: "801-111-1111", uid: 1, provider: "byzantine"}
  end

  let(:valid_user) do
    User.new valid_params
  end

  def User.sample
    order("RANDOM()").first
  end

  it "is valid with valid params" do
    valid_user.must_be :valid?
  end

  describe "#admin?" do
    it "should return true if the user has an admin-level position" do
      valid_user.positions = ["Member", "President"]
      valid_user.admin?.must_equal true
    end

    it "should return false if the user doesn't have an admin-level position" do
      valid_user.positions = ["Member", "Sergeant at Arms"]
      valid_user.admin?.must_equal false
    end
  end

  describe "#positions=" do
    it "should be have no positions if you assign an empty array" do
      valid_user.positions = []
      valid_user.positions.must_be_empty
    end

    it "should have the permissions of the array you assign to it" do
      positions = ["President", "Secretary"]
      valid_user.positions = positions
      valid_user.positions.must_equal positions
    end

    it "should assign the permissions, even if they are out of order" do
      valid_user.positions = ["Webmaster", "Treasurer", "President"]
      valid_user.positions.must_equal ["President", "Treasurer", "Webmaster"]
    end

    it "should raise an error if you assign a non-existent position" do
      ->{ valid_user.positions = ["Invalid Position"]}.must_raise User::PositionError
    end
  end

  describe "#positions_mask" do
    it "should return an empty array if the member has no positions" do
      user = User.new(valid_params.merge(positions_mask: 0))
      user.positions.must_be_empty
    end

    it "should return an array of the permissions it has" do
      # note: mask is calculated as a binary number left to right (backwards)
      # 0  1  2  3  4 => positions array
      # 1  2  4  8 16 => bitmask values
      # 1  0  1  0  0 => 5 (total)
      user = User.new(valid_params.merge(positions_mask: 5))
      user.positions.must_equal [User::POSITIONS[0], User::POSITIONS[2]]
    end
  end

  describe "#grant_position" do
    it "should add the position if the user doesn't have the position" do
      valid_user.positions = ["Member"]
      valid_user.grant_position("President")
      valid_user.has_position?("President").must_equal true
    end

    it "should leave positions unchanged if the user has the position" do
      initial_positions = ["Member", "President"]
      valid_user.positions = initial_positions
      valid_user.grant_position("Member")
      valid_user.positions.must_equal initial_positions
    end

    it "should raise an error if the position is invalid" do
      ->{ valid_user.grant_position("Invalid Position")}.must_raise User::PositionError
    end
  end

  describe "#revoke_position" do
    it "should remove the position if the user has the position" do
      valid_user.positions = ["Member", "President"]
      valid_user.revoke_position("President")
      valid_user.positions.must_equal ["Member"]
    end

    it "should leave positions unchanged if the user doesn't have the position" do
      valid_user.positions = ["Member", "President"]
      valid_user.revoke_position("Webmaster")
      valid_user.positions.must_equal ["Member", "President"]
    end

    it "should raise an error if the position is invalid" do
      ->{ valid_user.revoke_position("Invalid Position")}.must_raise User::PositionError
    end
  end

  describe ".valid_position?" do
    it "should return true if the position is a Toastmasters position" do
      User.valid_position?("Vice President Education").must_equal true
    end

    it "should return false if the position isn't a Toastmasters position" do
      User.valid_position?("Bystander").must_equal false
    end
  end

  describe ".find_with_id" do
    it "should return the user if the user with the provided id exists" do
      user = User.sample
      user.must_equal User.find_with_id(user.id)
    end

    it "should return nil if a user with the provided id doesn't exist" do
      User.find_with_id(-99).must_be_nil
    end
  end

  describe ".find_with_email" do
    it "should return the user with the matching email address" do
      user = User.sample
      User.find_with_email(user.email).must_equal user
    end

    it "should return nil if the email address doesn't match any users" do
      User.find_with_email("nonexisting@user.com").must_be_nil
    end
  end

  describe ".find_with_auth" do
    it "should return the user that matches the auth hash" do
      User.find_with_auth(justinian_auth_hash).must_equal users(:justinian)
    end

    it "should return nil if there are no matches for the auth hash" do
      new_auth_hash = {name: "New User", email: "new@user.com", phone: nil, uid: 1, provider: "tweetbook"}
      User.find_with_auth(new_auth_hash).must_be_nil
    end
  end

  describe ".create_with_auth" do
    it "should create a user from an auth hash" do
      auth_hash = {name: "Theodora Jones", email: "tj@example.com", phone: nil, uid: 2, provider: "byzantine"}
      user = User.create_with_auth(auth_hash)
      user.must_equal User.find_with_email(auth_hash[:email])
    end
  end
end
