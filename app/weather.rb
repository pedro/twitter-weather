require 'rubygems'
require 'active_support'

Dir['app/*'].each { |f| require f }

class Weather
  class << self
    def run
      connect
      return if posted_recently?
      Parser.parse
    end

    def posted_recently?
      Report.last && Report.last.created_at > Time.now - 20.minutes
    end

    def connect
      ActiveRecord::Base.establish_connection(
        :adapter => 'postgresql',
        :database => 'weather',
        :username => 'weather',
        :host => 'localhost'
      )
    end
  end
end

