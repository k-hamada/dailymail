require 'net/http'
require 'uri'
require 'json'

class WeatherService
  def fetch(city_id:)
    uri    = URI.parse("http://weather.livedoor.com/forecast/webservice/json/v1?city=#{city_id}")
    json   = Net::HTTP.get(uri)
    result = JSON.parse(json)
  end
end
