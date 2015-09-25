require_relative '../base_mustache'

require 'time'

module GoogleCalendarHelper
  def getDate(category)
    return '--:--' unless self[category]

    if self[category].key?('date')
      date   = self[category]['date']
      format = '%m/%d'
    elsif self[category].key?('dateTime')
      date   = self[category]['dateTime']
      format = '%H:%M'
    end
    Time.parse(date).strftime(format)
  end

  def startDate
    getDate('start')
  end

  def endDate
    getDate('end')
  end
end

class GoogleCalendar < BaseMustache
  include Logging
  include GoogleCalendarHelper

  def initialize(service, calendar_id)
    logger.info calendar_id

    today = Time.now
    tomorrow = today + (60 * 60 * 24)

    @service = service
    @result = @service.fetch(
      calendar_id: calendar_id,
      time_min: today.strftime('%FT00:00:00%:z'),
      time_max: tomorrow.strftime('%FT00:00:00%:z'),
    )
    @resource = @service.calendar_list['items'].find{|item| item['id'] == calendar_id }
  end

  def visible?
    logger.info 'visible?'

    @result.key?('items') && !@result['items'].empty?
  end

  def summary
    logger.info 'summary'

    @resource.fetch('summaryOverride', @result.fetch('summary'))
  end

  def items
    logger.info 'items'

    @result['items']
  end
end
