require 'thermometer/evaluate'

module Thermometer
  module ActiveRecord
    module RelationMethods
      include Evaluate::Temperatures

      private

      def sample_records options
        options = Thermometer.configuration.process_scope_options(proxy_association.reflection.options[:thermometer].merge(options))

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