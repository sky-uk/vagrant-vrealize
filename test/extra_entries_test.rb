require 'test_helper'

require 'vagrant-vrealize/extra-entries'

class ExtraEntriesTest < MiniTest::Test
  def test_can_set_string
    extras = ExtraEntries.new
    extras.string "foo", "bar"
    assert_equal([["foo", "bar"]], extras.of_type("string").to_a)
  end

  def test_can_set_integer
    extras = ExtraEntries.new
    extras.integer "foo", 1
    assert_equal([["foo", 1]], extras.of_type("integer").to_a)
  end

  def test_can_set_decimal
    extras = ExtraEntries.new
    extras.decimal "foo", 1
    assert_equal([["foo", 1]], extras.of_type("decimal").to_a)
  end

  def test_get_types_list
    extras = ExtraEntries.new
    extras.decimal "foo", 1
    assert_equal ['decimal'], extras.types
  end
end
