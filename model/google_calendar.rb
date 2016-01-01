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

    @service = service
    @result = @service.fetch(
      calendar_id: calendar_id,
      time_min: Date.today.to_time.strftime('%FT00:00:00%:z'),
      time_max: Date.today.next_day.to_time.strftime('%FT03:00:00%:z'),
    )
    @resource = @service.calendar_list['items'].find{|item| item['id'] == calendar_id }

    fix_empty_items!
    reject_finished_item!
  end

  def visible?
    logger.info 'visible?'

    not @result['items'].empty?
  end

  def summary
    logger.info 'summary'

    @resource.fetch('summaryOverride', @result.fetch('summary'))
  end

  def items
    logger.info 'items'

    @result['items']
  end

  private

  def fix_empty_items!
    unless @result.key?('items')
      @result['items'] = []
    end
  end

  # 現在時刻以前の時間に終了時間を迎えた予定は除外
  def reject_finished_item!
    now = Time.now
    @result['items'].reject! do |item|
      item['end'].key?('dateTime') &&
      ((Time.parse(item['end']['dateTime']) <=> now) < 1)
    end
  end
end
