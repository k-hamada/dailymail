require 'mustache'

require_relative 'logging'
require_relative 'memorizable'
include Memoizable

class BaseMustache < Mustache
  include Logging

  self.template_path = File.dirname(__FILE__)

  def initialize
    logger.info 'Initialize'
  end
end
