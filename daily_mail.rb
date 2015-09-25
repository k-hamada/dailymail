require_relative 'model/weather'
require_relative 'service/weather_service'
require_relative 'model/google_calendar'
require_relative 'service/google_calendar_service'
require_relative 'service/send_mail_service'
require_relative 'util/logging'

class DailyMail
  include Logging

  def weather
    logger.info 'weather'

    service = WeatherService.new

    weather_ids = ENV['WEATHER_CITY_IDS'].split(';')
    weather_ids.map{|city_id|
      weather = Weather.new(service, city_id)
      weather.render
    }.join
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

  def send!
    logger.info 'send'

    service = SendMailService.new
    service.mail.body = [weather, calendar].join("\n")
    service.send!
  end
end

if __FILE__ == $PROGRAM_NAME
  daily_mail = DailyMail.new
  daily_mail.send!
end

