require File.dirname(__FILE__) + '/base'

describe Condition do
  before do
    @hot = Condition.new(36)
    @windy = Condition.new(24)
  end

  it "knows the description" do
    @hot.to_s.should == 'hot'
  end

  it "detects a change when code and description are different" do
    @hot.changed?(@windy).should be_true
  end

  it "deals with stupid duplicate codes" do
    Condition.new(11).changed?(Condition.new(12)).should be_false
  end
end