# frozen_string_literal: true
require_relative 'base_test'

class ActiveRecord::OrderedEnum::IntegerColumTest < ActiveRecord::OrderedEnum::BaseTest
  def setup
    ActiveRecord::Base.connection.create_table(:perverts, force: true) do |t|
      t.integer :status
    end
  end

  def test_type
    assert(record.status_before_type_cast.is_a?(Numeric))
  end

  def record_class
    Pervert
  end
end
