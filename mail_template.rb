require 'mustache'
require 'date'
require_relative 'weather'

class MailTemplate < Mustache
  self.template_path = File.dirname(__FILE__)

  DATE_TEMPLATE = '%Y/%m/%d(%a)'
  CITY = '130010'

  def date
    Date.today.strftime(DATE_TEMPLATE)
  end

  def weather
    weather = Weather.new(CITY)
    weather.render
  end
end

if __FILE__ == $PROGRAM_NAME
  puts MailTemplate.render
end
