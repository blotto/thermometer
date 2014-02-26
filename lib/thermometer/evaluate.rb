module Thermometer
  module Evaluate
    module CalcsForTime

      def time_diff_for(date, increment: :days, reference: DateTime.now)
        now = Time.at(reference)
        diff = (now - date).to_i
        (diff.to_f/1.send(increment)).send(increment)
      end

      ##
      # @sample is an array of timestamps
      # @reference is a point in time to evaluate the time_diff
      def average(sample, increment: :days, reference: DateTime.now)
        (sample.map { |s| time_diff_for(s,increment: increment,reference: reference)  }.
            inject{ |d,e| d+ e}.to_f / sample.size.send(increment)).send(increment)
      end

      def min

      end

      def max

      end
    end

    module Temperatures
      include Thermometer::Evaluate::CalcsForTime

      def has_temperature(options={})
        date_reference =  options[:date_reference].nil? ? DateTime.now : options[:date_reference]
        sample = sample_records options

        if sample.size > 1
          evaluate_level(average(sample,  reference: date_reference))
        elsif sample.size == 1
          evaluate_level(time_diff_for(sample.first, reference: date_reference))
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

      def compare_level_to(level, options)
        yield Thermometer.configuration.default_time_range[level].max,
            Thermometer.configuration.default_time_range[has_temperature(options)].min
      end

      def sample_records
        raise "Subclass is responsible for defining this method."
      end


    end
  end
end
