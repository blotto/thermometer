module Thermometer
  module Evaluate
    module CalcsForTime

      def time_diff_for(date, opts={}) # increment: :days, reference: DateTime.now)
        defaults = {:increment => :days}
        opts = defaults.merge(opts)
        now = Time.at(opts[:reference])
        diff = (now - date).to_i
        (diff.to_f/1.send(opts[:increment])).send(opts[:increment])
      end

      ##
      # @sample is an array of timestamps
      # @reference is a point in time to evaluate the time_diff
      def average(sample, opts={} ) #increment: :days, reference: DateTime.now)
        defaults = {:increment => :days}
        opts = defaults.merge(opts)
        (sample.map { |s| time_diff_for(s,:increment => opts[:increment],:reference => opts[:reference])  }.
            inject{ |d,e| d+ e}.to_f / sample.size.send(opts[:increment])).send(opts[:increment])
      end

      def min

      end

      def max

      end
    end

    module Temperatures
      include Thermometer::Evaluate::CalcsForTime

      def heat_map(first , last= DateTime.now , options={})
        heat_map = Hash.new

        first = first.to_datetime if first.is_a?(ActiveSupport::TimeWithZone)
        last = last.to_datetime if last.is_a?(ActiveSupport::TimeWithZone)

        first.upto(last).each do |d|
          #heat_map[d.strftime('%F')] = self.has_temperature options.merge({:date_reference => d})
          yield d, self.has_temperature(options.merge({:date_reference => d}))
        end
        #return heat_map
      end

      def heat_map_scaled(first , last= DateTime.now , options={})
        self.heat_map(first, last, options) do |d,t| yield d, scale_for(t) end
      end

      def has_temperature(options={})
        date_reference =  options[:date_reference].nil? ? DateTime.now : options[:date_reference]
        sample = sample_records options

        if sample.size > 1
          evaluate_level(average(sample,  :reference => date_reference))
        elsif sample.size == 1
          evaluate_level(time_diff_for(sample.first, :reference => date_reference))
        else
          :none
        end
      end

      ##
      # Read the direct read_temperature on the instance itself
      #
      def has_temperature?(level,options={})
        level.to_s == has_temperature(options).to_s
      end

      def is_warmer_than?(level,options={})
        compare_level_to(level,options) do |x,y|
          x > y
        end
      end

      def is_colder_than?(level,options={})
        compare_level_to(level,options) do |x,y|
          x < y
        end
      end

      private

      def evaluate_level(days, ranges=Thermometer.configuration.default_time_range)
        level = :none
        ranges.each do |k,v|
          if v.include?(days)
            level = k
            break
          end
        end
        return level
      end

      def compare_level_to(level1, options)
        time_range = Thermometer.configuration.default_time_range

        level2 = has_temperature(options)

        yield1 = time_range.has_key?(level1) ? time_range[level1].max : 0
        yield2 = time_range.has_key?(level2) ? time_range[level2].max : 0

        yield yield1, yield2
      end

      def scale_for key
        @hash ||= Hash[Thermometer.configuration.default_time_range.keys.map.with_index.to_a]
        @hash[key].nil? ? 0 : @hash[key]
      end

      def sample_records
        raise "Subclass is responsible for defining this method."
      end


    end
  end
end
