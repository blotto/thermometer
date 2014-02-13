module Thermometer
  class Configuration
    def initialize
      @config = YAML.load_file("#{Rails.root.to_s}/config/thermometer.yml")[Rails.env]
      load_time_ranges
      load_scope_options
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
      @sample ||= @config['sample'].to_i
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
       @default_time_range ||= @time_ranges[@config['time_range']]
    end

    def scope_options
      @scope_options
    end

    def process_scope_options options=nil
      unless options.nil?
        date_field = options.include?(:date) ? options[:date] : self.date
        ordering = options.include?(:order) && %w(ASC DESC).include?(options[:order].to_s.upcase) ?
            options[:order].to_s.upcase : self.order
        limits = options.include?(:sample) ? options[:sample].to_i : self.sample
        options = {date: date_field, order: "#{date_field} #{ordering}", limit: limits}
      else
        options = @scope_options
      end
      return options
    end

    private

    def load_scope_options
      @scope_options = Hash.new
      @scope_options[:date] = self.date
      @scope_options[:order] = "#{@scope_options[:date]} #{self.order}"
      @scope_options[:limit] = self.sample
    end

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
