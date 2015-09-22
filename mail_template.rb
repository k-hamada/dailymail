require_relative 'base_mustache'
require_relative 'model/weather'
require_relative 'service/weather_service'
require_relative 'model/google_calendar'
require_relative 'service/google_calendar_service'

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

  def calendar
    logger.info 'calendar'

    service = GoogleCalendarService.new

    calendar_ids = ENV['GOOGLE_CALENDAR_IDS'].split(';')
    calendar_ids.map{|calendar_id|
      calendar = GoogleCalendar.new(service, calendar_id)
      calendar.render
    }.join
  end
end

if __FILE__ == $PROGRAM_NAME
  puts MailTemplate.render
end
