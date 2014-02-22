require 'thermometer/evaluate'

module Thermometer
  module ActiveRecord

    module QueryMethods

      def sample options
        if options[:limit] && options[:order]
          sample = limit(options[:limit]).order(options[:order]).pluck(options[:date])
        elsif options[:limit] && options[:order].nil?
          sample = limit(options[:limit]).pluck(options[:date])
        elsif options[:limit].nil? && options[:order]
          sample = order(options[:order]).pluck(options[:date])
        else
          sample = pluck(options[:date])
        end
      end

    end

    module RelationMethods
      include Evaluate::Temperatures
      include ActiveRecord::QueryMethods

      private

      def sample_records options
        options = Thermometer.configuration.process_scope_options(proxy_association.reflection.options[:thermometer].merge(options))

        sample options
      end


    end
  end

  #::ActiveRecord::Base.extend RelationMethods

end


#ActiveRecord::Relation.send(:include, Thermometer::ActiveRecord::RelationMethods)