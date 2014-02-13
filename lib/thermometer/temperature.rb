module Thermometer
  module Temperature



    extend ActiveSupport::Concern

    def self.included(base)
      base.extend ClassMethods
    end


    module ClassMethods

      ##
      # Takes one or more associations and defines methods to read temperature per
      # association
      #
      def measure_the_heat_on *associations
        options = associations.extract_options!
        date_field = options.include?(:date) ? options[:date] : Thermometer.configuration.date
        ordering = options.include?(:order) && %w(ASC DESC).include?(options[:order].to_s.upcase) ?
            options[:order].to_s.upcase : Thermometer.configuration.order
        limit = options.include?(:sample) ? options[:sample].to_i : Thermometer.configuration.sample

        associations.each do |association|
          class_eval do
            define_method "read_temperature_on_#{association}" do
              if ordering
                records = send(association).order("#{date_field} #{ordering}").limit(limit)
              else
                records = send(association).limit(limit)
              end
              if records.first
                evaluate_level(time_diff_for(records.first.send(Thermometer.configuration.date)))
              else
                :none
              end
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
      def temperature
        evaluate_level(time_diff_for(updated_at))
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

      def time_diff_for(date, increment=:days)
        now = Time.at(DateTime.now)
        diff = (now - date).to_i
        (diff.to_f/1.send(increment)).send(increment)
      end

    end

  end
end

ActiveRecord::Base.send :include, Thermometer::Temperature
