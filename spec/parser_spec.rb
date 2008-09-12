require File.dirname(__FILE__) + '/base'

describe Parser do
  it "attempts to create a Report with attributes parsed from the Yahoo forecast api" do
    Parser.stub!(:yahoo_api_weather_rss).and_return($rss)
    Report.should_receive(:create_if_interesting).with(:temperature => '57', :condition => '29')
    Parser.parse
  end
end

$rss = <<EOFRSS
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<rss version="2.0" xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
<channel>
  <item>
    <title>Conditions for San Francisco, CA at 11:56 pm PDT</title>
    <geo:lat>37.77</geo:lat>
    <geo:long>-122.42</geo:long>
    <link>http://us.rd.yahoo.com/dailynews/rss/weather/San_Francisco__CA/*http://weather.yahoo.com/forecast/94103_f.html</link>
    <pubDate>Wed, 10 Sep 2008 11:56 pm PDT</pubDate>
    <yweather:condition  text="Partly Cloudy"  code="29"  temp="57"  date="Wed, 10 Sep 2008 11:56 pm PDT" />
    <etc>...</etc>
  </item>
</channel>
</rss>
EOFRSS
