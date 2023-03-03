require "second_amendment_wholesale/base"
require "second_amendment_wholesale/version"

require "second_amendment_wholesale/api"
require "second_amendment_wholesale/attribute"
require "second_amendment_wholesale/catalog"
require "second_amendment_wholesale/category"
require "second_amendment_wholesale/error"
require "second_amendment_wholesale/inventory"
require "second_amendment_wholesale/order"
require "second_amendment_wholesale/response"
require "second_amendment_wholesale/user"

module SecondAmendmentWholesale

  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield(config)
  end

  class Configuration
    # attr_accessor :debug_mode

    def initialize
      # @debug_mode     ||= false
    end
  end
end

