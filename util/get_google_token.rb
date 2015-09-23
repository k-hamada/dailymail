require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'

CREDENTIAL_STORE_FILE = 'dailymail-oauth2.json'

client = Google::APIClient.new(
  application_name:    'Daily Mail',
  application_version: '0.9.9',
)
file_storage = Google::APIClient::FileStorage.new(CREDENTIAL_STORE_FILE)

if file_storage.authorization.nil?
  client_secrets = Google::APIClient::ClientSecrets.load

  flow = Google::APIClient::InstalledAppFlow.new(
    client_id:     client_secrets.client_id,
    client_secret: client_secrets.client_secret,
    scope:         ['https://www.googleapis.com/auth/calendar.readonly']
  )

  client.authorization = flow.authorize(file_storage)
end

puts [
  'config:set',
  "CLIENT_ID=#{client.authorization.client_id}",
  "CLIENT_SECRET=#{client.authorization.client_secret}",
  "REFRESH_TOKEN=#{client.authorization.refresh_token}",
  "ACCESS_TOKEN=#{client.authorization.access_token}",
].join
