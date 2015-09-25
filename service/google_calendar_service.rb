require 'google/api_client'

class GoogleCalendarService
  def initialize
    @client = Google::APIClient.new(
      application_name:    'Daily Mail',
      application_version: '0.9.9',
    )
    @client.authorization.client_id     = ENV['CLIENT_ID']
    @client.authorization.client_secret = ENV['CLIENT_SECRET']
    @client.authorization.refresh_token = ENV['REFRESH_TOKEN']
    @client.authorization.access_token  = ENV['ACCESS_TOKEN']
    @client.authorization.scope         = ['https://www.googleapis.com/auth/calendar.readonly']

    @calendar = @client.discovered_api('calendar', 'v3')
  end

  def fetch(calendar_id:, time_min:, time_max:)
    params = {
      calendarId:   calendar_id,
      timeMin:      time_min,
      timeMax:      time_max,
      orderBy:      'startTime',
      fields:       'description,items(description,end,htmlLink,id,location,start,summary),summary',
      singleEvents: 'True',
    }

    result = @client.execute(:api_method => @calendar.events.list,
                            :parameters => params)
    JSON.parse(result.response.body)
  end

  def calendar_list
    @calendar_list ||= @client.execute(:api_method => @calendar.calendar_list.list)
    JSON.parse(@calendar_list.response.body)
  end
end
