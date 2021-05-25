# frozen_string_literal: true

# This model use integer value column for enum
class Pervert < ActiveRecord::Base
  include ActiveRecord::OrderedEnum
  enum(status: %I[placed processed closed], _default: :placed)
  ordered_enum(:status)
end
