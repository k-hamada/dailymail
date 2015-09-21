require 'mustache'

require_relative 'util/logging'
require_relative 'util/memorizable'
include Memoizable

TEMPLATE_DIR = '/view'

class BaseMustache < Mustache
  include Logging

  self.template_path = File.dirname(__FILE__) + TEMPLATE_DIR

  def initialize
    logger.info 'Initialize'
  end
end
