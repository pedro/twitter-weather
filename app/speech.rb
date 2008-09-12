module Speech
  class Base
    attr_accessor :report
    def self.text_for(report)
      new(report).text
    end

    def initialize(report)
      @report = report
    end
  end

  class Greeting < Base
    def text
      good_morning || good_night || neutral_greeting
    end

    def good_morning
      text = "good morning!"
      if morning? && Report.all_today.select { |r| r.tweet =~ /#{text}/ }.empty?
        return text
      end
    end

    def good_night
      text = "good night."
      if night? && Report.all_today.select { |r| r.tweet =~ /#{text}/ }.empty?
        return text
      end
    end

    def neutral_greeting
      ['hey!', 'hello there,', 'dude.', 'hi,', 'hai,'].rand
    end

    def morning?
      (5..9).include?(Time.now.hour)
    end

    def night?
      (19..21).include?(Time.now.hour)
    end
  end

  class CurrentTimeReference < Base
    def text
      ['right now:', 'outside:', 'at this time:', 'as for now:', 'here in SF:'].rand
    end
  end

  class WeatherDescription < Base
    def text
      text = "#{report.condition}, #{report.temperature.degrees}F"
      text = "still #{text}" if Report.last && Report.last.condition.changed?(report.condition)
      text
    end
  end

  def self.build_tweet(report)
    tweet = ''
    [Greeting, CurrentTimeReference, WeatherDescription].each do |klass|
      part = klass.text_for(report)
      # wtf? maybe it's time to sleep
      part = part[0,1].upcase + part[1,part.size] if ['.', '!', nil].include? tweet.strip[-1,1]
      tweet << part + ' '
    end
    tweet.strip
  end
end