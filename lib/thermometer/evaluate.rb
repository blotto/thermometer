module Thermometer
  module Evaluate
    module Temperatures
      include Time

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


    end

    module Time

      def time_diff_for(date, increment=:days, reference=DateTime.now)
        now = Time.at(reference)
        diff = (now - date).to_i
        (diff.to_f/1.send(increment)).send(increment)
      end

      ##
      # @sample is an array of timestamps
      # @reference is a point in time to evaluate the time_diff
      def average(sample, increment=:days, reference=DateTime.now)
        (sample.map { |s| time_diff_for(date: s, reference: reference)  }.inject{ |d,e| d+ e}.to_f / sample.size.send(increment))
      end

      def min

      end

      def max

      end
    end
  end
end
