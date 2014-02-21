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

   ###

   test "instance should return a value from has_temperature" do
     assert_not_nil users(:user_1).has_temperature
   end

   test "instance should return a value from has_temperature?" do
     assert_not_nil users(:user_1).has_temperature? :warm
   end

   test "instance should return a value from is_colder_than?" do
     assert_not_nil users(:user_1).is_colder_than? :warm
   end

   test "instance should return a value from is_warmer_than?" do
     assert_not_nil users(:user_1).is_warmer_than? :warm
   end

   test "instance association messages should return a value from has_temperature" do
     assert_not_nil users(:user_1).messages.has_temperature
   end

   test "instance association messages should return a value from has_temperature?" do
     assert_not_nil users(:user_1).messages.has_temperature?  :warm
   end

   test "instance association messages should return a value from is_colder_than?" do
     assert_not_nil users(:user_1).messages.is_colder_than?  :warm
   end

   test "instance association messages should return a value from is_warmer_than?" do
     assert_not_nil users(:user_1).messages.is_warmer_than?  :warm
   end

   test "Class should return a value from has_temperature" do
     assert_not_nil User.has_temperature
   end

   test "Class should return a value from has_temperature?" do
     assert_not_nil User.has_temperature?  :warm
   end

   test "Class should return a value from is_colder_than?" do
     assert_not_nil User.is_colder_than?  :warm
   end

   test "Class should return a value from is_warmer_than?" do
     assert_not_nil User.is_warmer_than?  :warm
   end

   ### overides for options

   test "instance should return a value from has_temperature" do
     assert_not_nil users(:user_1).has_temperature :sample => 3
   end

   test "instance should return a value from has_temperature?" do
     assert_not_nil users(:user_1).has_temperature? :warm , :sample => 3
   end

   test "instance should return a value from is_colder_than?" do
     assert_not_nil users(:user_1).is_colder_than? :warm , :sample => 3
   end

   test "instance should return a value from is_warmer_than?" do
     assert_not_nil users(:user_1).is_warmer_than? :warm , :sample => 3
   end

   test "instance association messages should return a value from has_temperature" do
     assert_not_nil users(:user_1).messages.has_temperature
   end

   test "instance association messages should return a value from has_temperature?" do
     assert_not_nil users(:user_1).messages.has_temperature?  :warm , :sample => 3 , :order => 'asc'
   end

   test "instance association messages should return a value from is_colder_than?" do
     assert_not_nil users(:user_1).messages.is_colder_than?  :warm , :sample => 3
   end

   test "instance association messages should return a value from is_warmer_than?" do
     assert_not_nil users(:user_1).messages.is_warmer_than?  :warm , :order => 'asc'
   end

   test "Class should return a value from has_temperature" do
     assert_not_nil User.has_temperature
   end

   test "Class should return a value from has_temperature?" do
     assert_not_nil User.has_temperature?  :warm , :sample => 3
   end

   test "Class should return a value from is_colder_than?" do
     assert_not_nil User.is_colder_than?  :warm , :sample => 3
   end

   test "Class should return a value from is_warmer_than?" do
     assert_not_nil User.is_warmer_than?  :warm , :sample => 3
   end



end