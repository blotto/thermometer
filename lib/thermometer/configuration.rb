module Thermometer
  class Configuration
    def initialize
      @config = YAML.load_file("#{Rails.root.to_s}/config/thermometer.yml")[Rails.env]
      load_time_ranges
    end

    def config
      @config
    end

    def time_ranges
       @time_ranges
    end

    ##
    # Defines the date filed in ActiveRecord Model to inspect
    #
    def date
      @date ||= @config['date']
    end

    ##
    # Defines how many records to sample
    #
    def sample
      @sample ||= @config['sample']
    end

    ##
    # Default sort order on Collection
    #
    def order
      unless @order
        raise "'order' must be one of [ASC,DESC]" if !%w(ASC DESC).include?(@config['order'].to_s.upcase)
      end
      @order ||= @config['order']
    end

    ##
    #  If no range is called expclitly, use this one
    #
    def default_time_range
       @default_time_range ||= @time_ranges[@config['default_time_range']]
    end

    private

    ##
    #  Load ranges from config file
    #
    def load_time_ranges
      @time_ranges = ActiveSupport::HashWithIndifferentAccess.new
      time_ranges = @config['time']
      time_ranges.each do |t,r|
        time_range = ActiveSupport::HashWithIndifferentAccess.new
        src_ranges ||= r
        src_ranges.map { |k,v| time_range[k.to_sym] = rangify_time_boundaries(v) }
        @time_ranges[t.to_sym] = time_range
      end

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
