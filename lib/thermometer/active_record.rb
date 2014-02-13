require 'thermometer/evaluate'

module Thermometer
  module ActiveRecord
    module RelationMethods
      include Evaluate::Temperatures

      def temperature *args
        load
        if size > 1
          sample = self.map(&:Thermometer.configuration.date)
          evaluate_level(average(sample))
        else
          evaluate_level(time_diff_for(self.first.send(Thermometer.configuration.date)))
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
