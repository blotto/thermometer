module Thermometer
  module ActiveRecord
    module RelationMethods

      def temperature *args
        if eager_loading?
          unscoped.load
        else
          load
        end
        evaluate_level(time_diff_for(self.first.send(Thermometer.configuration.date)))
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
