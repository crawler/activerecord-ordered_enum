# frozen_string_literal: true

# This model use sting value column for enum
class Straight < ActiveRecord::Base
  include ActiveRecord::OrderedEnum
  enum(status: { placed: 'placed', processed: 'processed', closed: 'closed'}, _default: :placed)
  ordered_enum(:status)
end
