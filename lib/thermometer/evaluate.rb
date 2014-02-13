module Thermometer
  module Evaluate
    module Temperatures
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

      def time_diff_for(date, increment=:days)
        now = Time.at(DateTime.now)
        diff = (now - date).to_i
        (diff.to_f/1.send(increment)).send(increment)
      end

    end
  end
end
