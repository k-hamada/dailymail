require 'mail'
require_relative 'mail_template'
require 'date'

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

if __FILE__ == $PROGRAM_NAME
  return if ENV['TO_MAIL_ADDRESS'].nil? || ENV['FROM_MAIL_ADDRESS'].nil?

  Mail.deliver do
    to      ENV['TO_MAIL_ADDRESS']
    from    ENV['FROM_MAIL_ADDRESS']
    subject Date.today.strftime('%Y/%m/%d (%a)')
    body    MailTemplate.render
    charset 'utf-8'
  end
end
