# frozen_string_literal: true

require_relative "../../test_helper"

class ActiveRecord::OrderedEnum::BaseTest < TestCase
  self.abstract_test = true

  def record
    record_class.create do |record|
      record.status = :processed
    end
  end

  def test_exactly?
    assert(record.status_exactly?(:processed))
  end

  def test_to?
    assert(record.status_to?(:processed))
    refute(record.status_to?(:processed, exclusive: true))
  end
end
