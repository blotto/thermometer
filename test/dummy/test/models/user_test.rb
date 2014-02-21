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

   test "instance should return a value from has_temperature with options" do
     assert_not_nil users(:user_1).has_temperature  :sample => 3 , :order => 'asc'
   end

   test "instance should return a value from has_temperature? with options" do
     assert_not_nil users(:user_1).has_temperature? :warm , :sample => 3
   end

   test "instance should return a value from is_colder_than? with options" do
     assert_not_nil users(:user_1).is_colder_than? :warm , :order => 'asc'
   end

   test "instance should return a value from is_warmer_than? with options" do
     assert_not_nil users(:user_1).is_warmer_than? :warm , :sample => 3
   end

   test "instance association messages should return a value from has_temperature with options" do
     assert_not_nil users(:user_1).messages.has_temperature  :date => :created_at
   end

   test "instance association messages should return a value from has_temperature? with options" do
     assert_not_nil users(:user_1).messages.has_temperature?  :warm , :sample => 3 , :order => 'asc'
   end

   test "instance association messages should return a value from is_colder_than? with options" do
     assert_not_nil users(:user_1).messages.is_colder_than?  :warm , :sample => 3
   end

   test "instance association messages should return a value from is_warmer_than? with options" do
     assert_not_nil users(:user_1).messages.is_warmer_than?  :warm , :order => 'asc'
   end

   test "Class should return a value from has_temperature with options" do
     assert_not_nil User.has_temperature :date => :created_at
   end

   test "Class should return a value from has_temperature? with options" do
     assert_not_nil User.has_temperature?  :warm , :explicit => true, :sample => 3
   end

   test "Class should return a value from is_colder_than? with options" do
     assert_not_nil User.is_colder_than?  :warm , :sample => 3 , :order => 'asc'
   end

   test "Class should return a value from is_warmer_than? with options" do
     assert_not_nil User.is_warmer_than?  :warm , :explicit => true, :order => 'asc'
   end

   test "Class should return a value from is_warmer_than? with NO options" do
     assert_not_nil User.is_warmer_than?  :warm , :explicit => true
   end

    ### calls wrap up

   test "Instance should return a value from has_temperatures" do
     assert_not_nil users(:user_1).has_temperatures
   end

   ### scopes

   test "Class scope should return a value from has_temperatures" do
     assert_not_nil User.name_like("Ms.").has_temperature
   end

   test "Instance scope should return a value from has_temperatures" do
     assert_not_nil users(:user_1).last_five_messages.has_temperature
   end



end