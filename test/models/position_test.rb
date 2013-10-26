require "test_helper"

describe Position do
  before do
    @position = Position.new
  end

  it "must be valid" do
    @position.valid?.must_equal true
  end
end
