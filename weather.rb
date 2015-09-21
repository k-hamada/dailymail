require 'net/http'
require 'uri'
require 'json'
require 'mustache'
require 'date'

require_relative 'memorizable'
include Memoizable

class Weather < Mustache
    self.template_path = File.dirname(__FILE__)

    def initialize(city = '130010')
        uri = URI.parse("http://weather.livedoor.com/forecast/webservice/json/v1?city=#{city}")
        json = Net::HTTP.get(uri)
        @result = JSON.parse(json)
    end

    def location
        (@result['location'] &&
         @result['location']['prefecture']) ||
        '-'
    end

    def today
        @result['forecasts'].find{|forecast| forecast['date'] == Date.today.to_s }
    end
    memoize :today

    def date
        today['data']
    end

    def telop
        today['telop']
    end

    def temperature_max_celsius
        (today['temperature'] &&
         today['temperature']['max'] &&
         today['temperature']['max']['celsius']) ||
        '-'
    end

    def temperature_min_celsius
        (today['temperature'] &&
         today['temperature']['min'] &&
         today['temperature']['min']['celsius']) ||
        '-'
    end
end

if __FILE__ == $0
  puts Weather.render
end
