module Thermometer
  class Configuration
    def initialize
      @config = YAML.load_file("#{Rails.root.to_s}/config/thermometer.yml")[Rails.env]
      load_time_ranges
    end

    def config
      @config
    end

    def detailed_time_ranges
       @detailed_time_ranges
    end

    private

    ##
    #  Load ranges from config file
    #
    def load_time_ranges
      src_ranges ||= @config['detailed_time_ranges']
      src_ranges.map { |k,v| @detailed_time_ranges[k.to_sym] = rangify_time_boundaries(v) }
    end

    ##
    # Takes a string like "2.days..3.weeks"
    #  and converts to Range object -> 2.days..3.weeks
    #
    def rangify_time_boundaries(src)
      src.split("..").inject{ |s,e| s.split(".").inject{|n,m| n.to_i.send(m)}..e.split(".").inject{|n,m| n.to_i.send(m) }}
    end

  end
end
