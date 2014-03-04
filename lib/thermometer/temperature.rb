require 'thermometer/evaluate'

module Thermometer
  module Temperature
    extend ActiveSupport::Concern

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      include Evaluate::Temperatures
      include ActiveRecord::QueryMethods



      def acts_as_thermometer
        include Thermometer::Temperature::InstanceMethods
      end


      ##
      # Takes one or more associations and defines methods to read temperature per
      # association
      #
      def measures_temperature_for *associations

        options = associations.extract_options!


        associations.each do |association|
          class_eval do
            if reflections[association].respond_to?(:options)
              reflections[association].options[:thermometer] = options
              reflections[association].options[:extend] = Thermometer::ActiveRecord::RelationMethods
            end
          end


        end

      end


      private

      def sample_records options
        options = Thermometer.configuration.process_scope_options(options)
        Rails.logger.info (self.class.name) {options.inspect}
        data_sample options
      end

    end

    module InstanceMethods
      include Evaluate::Temperatures
      #include Evaluate::CalcsForTime


      ##
      # Rollup all associations and self into a hash
      #
      def has_temperatures options={}
        results = {}
        reflections.select {|r,v| v.options.has_key? :thermometer}.each do |r,v|
          results[r] = send(r).has_temperature options
        end
        results[:self] = has_temperature options

        return results
      end

      private

      def sample_records options
        options = Thermometer.configuration.process_scope_options(options)
        sample = [send(options[:date])]
      end

    end

  end
end

ActiveRecord::Base.send :include, Thermometer::Temperature
