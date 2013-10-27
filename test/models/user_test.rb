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
