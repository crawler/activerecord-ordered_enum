# frozen_string_literal: true

require_relative 'base_test'

class ActiveRecord::OrderedEnum::StringColumnTest < ActiveRecord::OrderedEnum::BaseTest
  def setup
    ActiveRecord::Base.connection.create_table(:straights, force: true) do |t|
      t.string :status
    end
  end

  def test_type
    assert(record.status_before_type_cast.is_a?(String))
  end

  def record_class
    Straight
  end
end
