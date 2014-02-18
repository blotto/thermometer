require 'thermometer/evaluate'

module Thermometer
  module ActiveRecord
    module RelationMethods
      include Evaluate::Temperatures

      def has_temperature(options=nil, *args)
        options = Thermometer.configuration.process_scope_options(options)
        sample = limit(options[:limit]).order(options[:order]).pluck(options[:date])
        if sample.size > 1
          evaluate_level(average(sample))
        elsif sample.size == 1
          evaluate_level(time_diff_for(sample.first))
        else
          :none
        end
      end

      ##
      # Read the direct read_temperature on the instance itself
      #
      def has_temperature?(level)
        level.to_s == has_temperature.to_s
      end

      def is_warmer_than?(level)
        Thermometer.configuration.default_time_range[has_temperature].min <
        Thermometer.configuration.default_time_range[level].max
      end

      def is_colder_than?(level)
        Thermometer.configuration.default_time_range[has_temperature].min >
        Thermometer.configuration.default_time_range[level].max
      end


    end
=begin
    module Temperature

      def
      rel = if ::ActiveRecord::Relation === self
              self
            elsif !defined?(::ActiveRecord::Scoping) or ::ActiveRecord::Scoping::ClassMethods.method_defined? :with_scope
              # Active Record 3
              scoped
            else
              # Active Record 4
              all
            end

      rel = rel.extending(RelationMethods)
    end
=end
  end

  #::ActiveRecord::Base.extend RelationMethods

end


#ActiveRecord::Relation.send(:include, Thermometer::ActiveRecord::RelationMethods)