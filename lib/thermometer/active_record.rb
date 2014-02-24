require 'thermometer/evaluate'

module Thermometer
  module ActiveRecord

    module QueryMethods

      def data_sample options

        if options[:limit] && options[:order]
          sample = limit(options[:limit]).order(options[:order])#.pluck(options[:date])
        elsif options[:limit] #&& options[:order].nil?
          sample = limit(options[:limit])#.pluck(options[:date])
        else  #options[:order] #options[:limit].nil? &&
          sample = order(options[:order])
        end

        return sample.pluck(options[:date])
      end


      #def conditions options
      #  yield options[:limit],options[:order],options[:date]
      #end

    end

    module RelationMethods
      include Evaluate::Temperatures
      include ActiveRecord::QueryMethods

      private

      def sample_records options
        options = Thermometer.configuration.process_scope_options(proxy_association.reflection.options[:thermometer].merge(options))

        data_sample options
      end


    end
  end

  #::ActiveRecord::Base.extend RelationMethods

end


#ActiveRecord::Relation.send(:include, Thermometer::ActiveRecord::RelationMethods)