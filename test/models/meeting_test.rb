require "test_helper"

describe Meeting do
  before do
    @meeting = Meeting.new
  end

  it "must be valid" do
    @meeting.valid?.must_equal true
  end
end
