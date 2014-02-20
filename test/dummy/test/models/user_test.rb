require 'test_helper'

class UserTest < ActiveSupport::TestCase

   test "instance should respond to has_temperature" do
     assert users(:user_1).respond_to?(:has_temperature)
   end

   test "instance should respond to has_temperature?" do
     assert users(:user_1).respond_to?(:has_temperature?)
   end

   test "instance should respond to is_colder_than?" do
     assert users(:user_1).respond_to?(:is_colder_than?)
   end

   test "instance should respond to is_warmer_than?" do
     assert users(:user_1).respond_to?(:is_warmer_than?)
   end

   test "instance association messages should respond to has_temperature" do
     assert users(:user_1).messages.respond_to?(:has_temperature)
   end

   test "instance association messages should respond to has_temperature?" do
     assert users(:user_1).messages.respond_to?(:has_temperature?)
   end

   test "instance association messages should respond to is_colder_than?" do
     assert users(:user_1).messages.respond_to?(:is_colder_than?)
   end

   test "instance association messages should respond to is_warmer_than?" do
     assert users(:user_1).messages.respond_to?(:is_warmer_than?)
   end

   test "Class should respond to has_temperature" do
    assert User.respond_to?(:has_temperature)
   end

   test "Class should respond to has_temperature?" do
     assert User.respond_to?(:has_temperature?)
   end

   test "Class should respond to is_colder_than?" do
     assert User.respond_to?(:is_colder_than?)
   end

   test "Class should respond to is_warmer_than?" do
     assert User.respond_to?(:is_warmer_than?)
   end


end