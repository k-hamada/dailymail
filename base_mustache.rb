require 'mustache'

require_relative 'logging'
require_relative 'memorizable'
include Memoizable

TEMPLATE_DIR = '/view'

class BaseMustache < Mustache
  include Logging

  self.template_path = File.dirname(__FILE__) + TEMPLATE_DIR

  def initialize
    logger.info 'Initialize'
  end
end
