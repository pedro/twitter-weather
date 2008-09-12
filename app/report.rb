require 'active_record'
require 'active_support'
require 'twitter'

class Report < ActiveRecord::Base
  before_create :build_tweet, :publish

  def self.last
    find(:last)
  end

  def self.all_today
    @@all_today ||= find(:all, :conditions => "date_trunc('day', created_at) = current_date")
  end

  def self.create_if_interesting(attributes)
    report = new(attributes)
    report.save if report.interesting?
  end

  def condition
    @condition_instance ||= Condition.new(super)
  end

  def temperature
    @temperature_instance ||= Temperature.new(super)
  end

  def interesting?
    return false if not_a_good_time

    return true unless last = Report.last
    return true if last.older_than? 8.hours

    return true if last.condition.changed?(condition)

    temperature_change = last.temperature.qualify_change(temperature)
    return true if temperature_change == :big
    return true if temperature_change == :medium && last.older_than?(2.hours)
    return true if temperature_change == :small &&  last.older_than?(4.hours)
    false
  end

  def not_a_good_time
    (0..6).include? Time.now.hour # no one cares for live weather reports at this time
  end

  def build_tweet
    self.tweet = Speech.build_tweet(self)
  end

  def publish
    Twitter::Base.new(ENV['TWITTER_USER'], ENV['TWITTER_PASS']).update(self.tweet)
  end

  def older_than?(period)
    created_at < Time.now - period
  end
end