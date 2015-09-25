require 'mail'
require 'date'

require_relative '../util/logging'

Mail.defaults do
  delivery_method :smtp, {
    address:              'smtp.sendgrid.net',
    port:                 '587',
    domain:               'heroku.com',
    user_name:            ENV['SENDGRID_USERNAME'],
    password:             ENV['SENDGRID_PASSWORD'],
    authentication:       :plain,
    enable_starttls_auto: true,
  }
end

class SendMailService
  include Logging

  attr_reader :mail

  def initialize
    logger.info 'initialize'

    @mail = Mail.new do
      to   ENV['TO_MAIL_ADDRESS']
      from ENV['FROM_MAIL_ADDRESS']
    end
  end

  def send!
    logger.info 'send'

    @mail.subject ||= default_subject
    @mail.body    ||= default_body
    @mail.charset = 'utf-8'
    @mail.deliver
  end

  private

  def default_subject
    Date.today.strftime('%Y/%m/%d (%a)')
  end

  def default_body
    'DailyMail'
  end
end
