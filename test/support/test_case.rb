# frozen_string_literal: true

class TestCase < Minitest::Test
  class << self
    def runnable_methods
      abstract_test ? [] : super
    end

    private

    attr_accessor :abstract_test
  end
end
