require File.dirname(__FILE__) + '/base'

describe Weather do
  before do
    Weather.stub!(:connect) # we don't need db here
  end

  it "runs Parser if there's no previous report" do
    Report.stub!(:last).and_return(nil)
    Parser.should_receive(:parse)
    Weather.run
  end

  it "runs Parser if the previous report is old" do
    Report.stub!(:last).and_return(mock('last report', :created_at => Time.now - 2.days))
    Parser.should_receive(:parse)
    Weather.run
  end

  it "avoids parsing if there's a recent report already" do
    Report.stub!(:last).and_return(mock('last report', :created_at => Time.now - 2.minutes))
    Parser.should_not_receive(:parse)
    Weather.run
  end
end