require 'thermometer/evaluate'

module Thermometer
  module Temperature
    extend ActiveSupport::Concern

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      include Evaluate::Temperatures

      ##
      #
      #
      def temperature(options, *args)
        options = Thermometer.configuration.process_scope_options(options)
        sample = limit(options[:limit]).order(options[:order]).pluck(options[:date])
        if sample.size > 1
          evaluate_level(average(sample))
        else
          evaluate_level(time_diff_for(sample.first))
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
              if ordering
                records = send(association).order("#{options[:date]} #{options[:order]}").limit(options[:sample])
              else
                records = send(association).limit(options[:sample])
              end

              records.temperature

            end
          end
        end

        include Thermometer::Temperature::InstanceMethods

      end

      private

      ##def with_options
      #
      #end




    end

    module InstanceMethods

      ##
      # Rollup all read_temperatures into a hash
      #
      def read_temperature
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

      private



    end

  end
end

ActiveRecord::Base.send :include, Thermometer::Temperature
