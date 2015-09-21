require_relative 'base_mustache'

require 'net/http'
require 'uri'
require 'json'
require 'date'

class Weather < BaseMustache
  include Logging

  def initialize(city = '130010')
    super()

    uri = URI.parse("http://weather.livedoor.com/forecast/webservice/json/v1?city=#{city}")
    json = Net::HTTP.get(uri)
    @result = JSON.parse(json)
  end

  def location
    logger.info 'location'

    (@result['location'] &&
     @result['location']['prefecture']) || '-'
  end

  def today
    logger.info 'today'

    @result['forecasts'].find{|forecast| forecast['date'] == Date.today.to_s }
  end
  memoize :today

  def date
    logger.info 'date'

    today['data']
  end

  def telop
    logger.info 'telop'

    today['telop']
  end

  def temperature_max_celsius
    logger.info 'temperature_max_celsius'

    (today['temperature'] &&
     today['temperature']['max'] &&
     today['temperature']['max']['celsius']) || '-'
  end

  def temperature_min_celsius
    logger.info 'temperature_min_celsius'

    (today['temperature'] &&
     today['temperature']['min'] &&
     today['temperature']['min']['celsius']) || '-'
  end
end

if __FILE__ == $PROGRAM_NAME
  puts Weather.render
end
