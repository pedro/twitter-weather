require File.dirname(__FILE__) + '/base'

describe Report do
  before(:all) do
    @last = Report.new(:temperature => 65, :condition => 27, :created_at => Time.now - 4.hours)
    Report.stub!(:last).and_return(@last)
  end

  before(:each) do
    @report = Report.new(@last.attributes)
  end

  it "is composed of condition" do
    @report.condition.should be_an_instance_of(Condition)
    @report.condition.to_s.should == 'mostly cloudy'
  end

  it "is composed of temperature" do
    @report.temperature.should be_an_instance_of(Temperature)
    @report.temperature.degrees.should == 65
  end

  context "interestingness" do
    before do
      @report.stub!(:not_a_good_time).and_return(false)
    end

    it "is interesting when there's no previous report" do
      @last = nil
      @report.should be_interesting
    end

    it "is interesting when the last report was a long time ago" do
      @last.created_at = Time.now - 1.day
      @report.should be_interesting
    end

    it "is interesting when temperature changed a lot" do
      @report.temperature = 60
      @report.should be_interesting
    end

    it "is interesting when the condition changed" do
      @report.condition = 10
      @report.should be_interesting
    end

    it "is interesting when there's a medium change of temperature and it's been a while since the last report" do
      @last.created_at = Time.now - 3.hours
      @report.temperature = 63
      @report.should be_interesting
    end

    it "is interesting when there's a small change of temperature and it's been a long time since the last report" do
      @last.created_at = Time.now - 5.hours
      @report.temperature = 65
      @report.should be_interesting
    end

    it "is not interesting when temperature/condition didn't change" do
      @report.should_not be_interesting
    end
  end
end