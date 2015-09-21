require 'mustache'

class MailTemplate < Mustache
    self.template_path = File.dirname(__FILE__)
end

if __FILE__ == $0
  puts MailTemplate.render
end
