$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "second_amendment_wholesale"

require 'active_support'
require 'active_support/core_ext'
require 'webmock/rspec'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include FixtureHelper
end
