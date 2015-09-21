require_relative 'base_mustache'
require_relative 'weather'
require_relative 'service/weather_service'

require 'date'

class MailTemplate < BaseMustache
  DATE_TEMPLATE = '%Y/%m/%d(%a)'
  CITY = '130010'

  def date
    logger.info 'date'

    Date.today.strftime(DATE_TEMPLATE)
  end

  def weather
    logger.info 'weather'

    service = WeatherService.new(CITY)
    weather = Weather.new(service)
    weather.render
  end
end

if __FILE__ == $PROGRAM_NAME
  puts MailTemplate.render
end
