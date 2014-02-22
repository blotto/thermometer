require 'test_helper'

class ThermometerTest < ActiveSupport::TestCase
  test "Thermometer is a module" do
    assert_kind_of Module, Thermometer
  end

  test "Thermometer yields a configuration" do
    Thermometer.configure do |c|
      assert_instance_of Thermometer::Configuration ,  c
    end
  end

  test "Configuration as a config Hash" do
    assert_kind_of Hash, Thermometer.configuration.config,
  end

  test "Configuration has a config Hash" do
    assert_kind_of Hash, Thermometer.configuration.config,
  end

  test "Configuration has a time_ranges Hash" do
    assert_kind_of ActiveSupport::HashWithIndifferentAccess, Thermometer.configuration.time_ranges,
  end

  test "Configuration has a scope_options Hash" do
    assert_kind_of Hash, Thermometer.configuration.scope_options,
  end



end
