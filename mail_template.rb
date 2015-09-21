require 'mustache'
require 'date'

require_relative 'weather'
require_relative 'logging'

class MailTemplate < Mustache
  include Logging

  self.template_path = File.dirname(__FILE__)

  DATE_TEMPLATE = '%Y/%m/%d(%a)'
  CITY = '130010'

  def initialize
    logger.info 'Initialize'
  end

  def date
    logger.info 'date'

    Date.today.strftime(DATE_TEMPLATE)
  end

  def weather
    logger.info 'weather'

    weather = Weather.new(CITY)
    weather.render
  end
end

if __FILE__ == $PROGRAM_NAME
  puts MailTemplate.render
end
