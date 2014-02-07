module Thermometer
  module Temperature

    extend ActiveSupport::Concern

    def self.included(base)
      base.extend ClassMethods
    end


    module ClassMethods

      def heat_for_time *associations
        options = associations.extract_options!
        date_field = options.include?(:date) ? options[:date] : :updated_at
        ordering = options.include?(:order) && %w(ASC DESC).include?(options[:order].to_s.upcase) ?
            options[:order].to_s.upcase : nil

        associations.each do |association|
          class_eval do
            define_method "heat_for_time_#{association}" do
              if ordering
                records = send(association).order("#{date_field} #{ordering}").limit(1)
              else
                records = send(association).limit(1)
              end
              if records.first
                evaluate_level(time_diff_for(records.first.updated_at))
              else
                :none
              end
            end
          end
        end

        include Thermometer::Temperature::InstanceMethods

      end
    end

    module InstanceMethods

      def evaluate_level(days, ranges=Thermometer.configuration.detailed_time_ranges)

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

      def temperature
        evaluate_level(time_diff_for(updated_at))
      end

      def temperature_per_association
        results = {}
        self.methods.grep(/heat_for/).each do |method_name|
          key = method_name.to_s
          key.slice! "heat_for_time_"
          results[key] = send(method_name)
        end
        results
      end


    end

  end
end

ActiveRecord::Base.send :include, Thermometer::Temperature