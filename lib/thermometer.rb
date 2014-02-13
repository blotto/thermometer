module Thermometer
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end


require "active_record"

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'thermometer/configuration'
require "thermometer/evaluate"
require "thermometer/active_record"
require "thermometer/temperature"

$LOAD_PATH.shift

#if defined?(ActiveRecord::Base)
#  class ActiveRecord::Base
#    include Thermometer::Temperature
#  end
#end


