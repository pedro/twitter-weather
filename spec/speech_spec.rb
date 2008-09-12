require File.dirname(__FILE__) + '/base'

describe Speech::Greeting do
  before do
    @greeting = Speech::Greeting.new(@report)
  end

  it "says good morning if it's the first post of the day" do
    Report.stub!(:all_today).and_return([Report.new(:tweet => 'It is cold!')])
    @greeting.stub!(:morning?).and_return(true)
    @greeting.good_morning.should_not be_nil
  end

  it "doesn't say good morning when it's not in the morning" do
    @greeting.stub!(:morning?).and_return(false)
    @greeting.good_morning.should be_nil
  end

  it "doesn't say good morning twice" do
    Report.stub!(:all_today).and_return([Report.new(:tweet => 'good morning! It is cold')])
    @greeting.stub!(:morning?).and_return(true)
    @greeting.good_morning.should be_nil
  end
end

describe Speech do
  it "joins all parts with spaces" do
    Speech::Greeting.stub!(:text_for).and_return('Hello there,')
    Speech::CurrentTimeReference.stub!(:text_for).and_return('right now:')
    Speech::WeatherDescription.stub!(:text_for).and_return('windy, 65F')
    Speech.build_tweet(@report).should == "Hello there, right now: windy, 65F"
  end
end