require "test_helper"

class Activerecord::OrderedEnumTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Activerecord::OrderedEnum::VERSION
  end
end
