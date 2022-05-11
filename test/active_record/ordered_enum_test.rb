# frozen_string_literal: true

require_relative "../test_helper"

class ActiveRecord::OrderedEnumTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Activerecord::OrderedEnum::VERSION
  end
end
