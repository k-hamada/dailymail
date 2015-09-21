require 'mustache'
require 'date'

class MailTemplate < Mustache
    self.template_path = File.dirname(__FILE__)

    DATE_TEMPLATE = '%Y/%m/%d(%a)'

    def date
        Date.today.strftime(DATE_TEMPLATE)
    end
end

if __FILE__ == $0
  puts MailTemplate.render
end
