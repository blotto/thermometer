require 'thermometer/evaluate'

module Thermometer
  module ActiveRecord
    module RelationMethods
      include Evaluate::Temperatures

      def temperature *args
        date_attrib = Thermometer.configuration.date
        sample = pluck(date_attrib)
        #load
        if size > 1
          #sample = self.map(&date_attrib.to_sym)
          evaluate_level(average(sample).send(date_attrib.to_sym))
        else
          evaluate_level(time_diff_for(sample.first.send(date_attrib.to_sym)))
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

ActiveRecord::Relation.send(:include, Thermometer::ActiveRecord::RelationMethods)
