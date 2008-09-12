require File.dirname(__FILE__) + '/base'

describe Temperature do
  before do
    @warm = Temperature.new(87)
  end

  it "detects when there's no change" do
    @warm.qualify_change(Temperature.new(87)).should be_false
  end

  it "detects a small change" do
    @warm.qualify_change(Temperature.new(88)).should == :small
  end

  it "detects a medium change" do
    @warm.qualify_change(Temperature.new(89)).should == :medium
  end

  it "detects a big change" do
    @warm.qualify_change(Temperature.new(95)).should == :big
  end

  it "also detects changes when temperature gets lower" do
    @warm.qualify_change(Temperature.new(85)).should == :medium
  end
end