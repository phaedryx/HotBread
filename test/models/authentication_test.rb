require "test_helper"

describe Authentication do
  let(:valid_params) do
    user = User.first
    {provider: "valid", uid: "1", user_id: user.id}
  end

  let(:existing_auth_hash) do # matches existing auth
    {provider: "provider", uid: "1"}
  end

  let(:valid_authentication) do
    Authentication.new valid_params
  end

  it "is valid with valid params" do
    valid_authentication.must_be :valid?
  end

  describe ".find_with_auth" do
    it "should return an authentication when given a proper auth hash" do
      Authentication.find_with_auth(existing_auth_hash).must_equal authentications(:existing_authentication)
    end

    it "should return nil when given an auth hash that doesn't match" do
      Authentication.find_with_auth({provider: "unknown", uid: '1'}).must_be_nil
    end
  end

  describe ".create_with_auth" do
    it "should create an authentication when given a proper auth hash" do
      auth_hash = {provider: "new provider", uid: "1", name: "Caesar Augustus", email: "caesar@augustus.com"}
      authentication = Authentication.create_with_auth(auth_hash)
      authentication.must_equal Authentication.find_with_auth(auth_hash)
    end
  end
end
