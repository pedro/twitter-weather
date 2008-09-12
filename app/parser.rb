require 'hpricot'
require 'open-uri'

class Parser
  class << self
    def parse
      forecast = Hpricot(yahoo_api_weather_rss)
      Report.create_if_interesting(
        :temperature => forecast.at('yweather:condition')['temp'],
        :condition => forecast.at('yweather:condition')['code']
      )
    end

    def yahoo_api_weather_rss
      open("http://weather.yahooapis.com/forecastrss?p=94103")
    end
  end
end