require 'test_helper'

class UserTest < ActiveSupport::TestCase

   test "instance should respond to has_temperature" do
     assert users(:user_1).respond_to?(:has_temperature)
   end
end