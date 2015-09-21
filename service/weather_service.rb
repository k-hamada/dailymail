require 'net/http'
require 'uri'
require 'json'

class WeatherService
  def initialize(city)
    @city = city
  end

  def fetch
    uri    = URI.parse("http://weather.livedoor.com/forecast/webservice/json/v1?city=#{@city}")
    json   = Net::HTTP.get(uri)
    result = JSON.parse(json)
  end
end
