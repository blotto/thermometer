# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'coveralls'
Coveralls.wear!

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"


Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }




# see https://github.com/rails/rails/issues/4971 for why we cant test this method
#if ActiveSupport::TestCase.method_defined?(:fixture_path=)
ActiveSupport::TestCase.fixture_path = File.expand_path("../dummy/test/fixtures", __FILE__)
#end

# Load fixtures from the engine
class ActiveSupport::TestCase

  set_fixture_class :users => "User"

  fixtures :all
end
