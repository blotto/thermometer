require 'test_helper'

class UserTest < ActiveSupport::TestCase


   test "instance should respond to has_temperature" do
     p user(:user_1)
     assert user(:user_1).respond_to?(:has_temperature)
   end
end