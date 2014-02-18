require 'thermometer/evaluate'

module Thermometer
  module Temperature
    extend ActiveSupport::Concern

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      include Evaluate::Temperatures

      def acts_as_thermometer
        include Thermometer::Temperature::InstanceMethods
      end
    #end

    #module SingletonMethods

      ##
      #
      #
      def temperature(options=nil, *args)
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
      # Takes one or more associations and defines methods to read temperature per
      # association
      #
      def measure_the_heat_on *associations
        options = Thermometer.configuration.process_scope_options(associations.extract_options!)


        associations.each do |association|
          class_eval do
            define_method "read_temperature_on_#{association}" do
              records = send(association).order("#{options[:date]} #{options[:order]}").limit(options[:sample])
              records.has_temperature
            end
            association.extend Thermometer::ActiveRecord::RelationMethods
          end


        end

      end



      #end

      private

      ##def with_options
      #
      #end




    end

    module InstanceMethods
      include Evaluate::Temperatures
      include Evaluate::CalcsForTime


      ##
      # Rollup all read_temperatures into a hash
      #
      def has_temperatures
        results = {}
        self.methods.grep(/read_temperature_on/).each do |method_name|
          key = method_name.to_s
          key.slice! "read_temperature_on_"
          results[key] = send(method_name)
        end
        results
      end

      ##
      # Read the direct read_temperature on the instance itself
      #
      def has_temperature
        evaluate_level(time_diff_for(updated_at))
      end

      ##
      # Read the direct read_temperature on the instance itself
      #
      def has_temperature?(level)
        level.to_s == has_temperature.to_s
      end

      def is_warmer_than?(level)
        compare_level_to(level) do |x,y|
          x > y
        end
      end

      def is_colder_than?(level)
        compare_level_to(level) do |x,y|
          x < y
        end
      end




      private

      def compare_level_to(level)
         yield Thermometer.configuration.default_time_range[level].max,
             Thermometer.configuration.default_time_range[has_temperature].min
      end

    end

  end
end

ActiveRecord::Base.send :include, Thermometer::Temperature
