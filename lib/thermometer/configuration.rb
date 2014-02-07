module Thermometer
  class Configuration
    def initialize
      @config = YAML.load_file("#{Rails.root.to_s}/config/thermometer.yml")[Rails.env]
    end

    def config
      @config
    end

    def detailed_time_ranges
      @config['detailed_time_ranges']
    end

  end
end
