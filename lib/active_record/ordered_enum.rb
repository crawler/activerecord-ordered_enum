# frozen_string_literal: true

require "active_support/concern"

module ActiveRecord
  # Allows to ask information about order of enum values.
  # For example:
  #   class Order < ActiveRecord::Base
  #     include ActiveRecord::OrderedEnum
  #     enum status: [:pending, :processed, :cancelled]
  #     ordered_enum :status
  #   end
  #  Order.status_from(:pending).first.status_from?(:processed) == false
  #  Order.status_from(:processed).first.status_to?(:cancelled) == true
  module OrderedEnum
    autoload :VERSION, "activerecord/ordered_enum/version"
    extend ActiveSupport::Concern

    # @api private
    class Generator
      def initialize(klass:, enum_name:)
        @klass = klass
        @enum_name = enum_name
        @plural_enum_name = enum_name.to_s.pluralize
      end

      def generate
        define_base_answer_methods
        define_class_methods
        klass.send(:include, instance_methods)
        klass.send(:extend, class_methods)
      end

      private

      attr_reader :klass, :enum_name, :plural_enum_name

      def instance_methods
        @instance_methods ||= Module.new
      end

      def class_methods
        @class_methods ||= Module.new
      end

      def define_base_answer_methods
        instance_methods.module_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          def #{enum_name}_exactly?(desired)                          # def state_exactly?(desired)
            #{enum_name} == desired.to_s                              #   state == desired.to_s
          end                                                         # end
          # e.g. order.state_to?(:paid, exclusive: true)
          def #{enum_name}_to?(desired, exclusive: false)              # def state_to?(desired, exclusive: false)
            self.class.#{plural_enum_name}_to(                         #   self.class.states_to(
              desired, exclusive: exclusive                            #     desired, exclusive: exclusive
            ).include?(#{enum_name}.to_s)                              #   ).include?(state.to_s)
          end                                                          # end

          # e.g. order.state_from?(:paid)
          def #{enum_name}_from?(desired, exclusive: false)            # def state_from?(desired, exclusive: false)
            self.class                                                 #  self.class
              .#{plural_enum_name}_from(desired, exclusive: exclusive) #   .states_from(desired, exclusive: exclusive)
              .include?(#{enum_name}.to_s)                             #   .include?(state.to_s)
          end                                                          # end
        RUBY
      end

      def define_class_methods
        define_scope_class_methods
        define_selector_class_methods
        define_index_class_method
        define_exception_class_method
      end

      def define_scope_class_methods
        class_methods.module_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          # e.g. scope Order.state_from('placed')
          def #{enum_name}_from(desired, exclusive: false)
            where(#{enum_name}: #{plural_enum_name}_from(desired, exclusive: false))
          end

          # e.g. scope Order.state_to('placed')
          def #{enum_name}_to(desired, exclusive: false)
            where(#{enum_name}: #{plural_enum_name}_to(desired, exclusive: exclusive))
          end

          # e.g. scope Order.state('placed')
          def #{enum_name}(desired, exclusive: false)
            where(#{enum_name}: desired)
          end
        RUBY
      end

      def define_selector_class_methods
        class_methods.module_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          # e.g. Order.states_to 'payment'
          def #{plural_enum_name}_to(desired, exclusive: false)
            #{plural_enum_name}.keys[..(#{enum_name}_index(desired) - (exclusive ? 1 : 0))]
          end

          # e.g. Order.states_from 'paid'
          def #{plural_enum_name}_from(desired, exclusive: false)
            #{plural_enum_name}.keys[(#{enum_name}_index(desired) + (exclusive ? 1 : 0))..]
          end
        RUBY
      end

      def define_index_class_method
        class_methods.module_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          def #{enum_name}_index(desired)
            #{plural_enum_name}.keys.index(desired.to_s).tap do |index|
              raise_invalid_desired_#{enum_name}(desired) if index.nil?
            end
          end
        RUBY
      end

      def define_exception_class_method
        class_methods.module_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          def raise_invalid_desired_#{enum_name}(desired)
            raise(
              ArgumentError,
              "Invalid desired \\"\#\{desired\}\\" argument passed to " \
              "\#\{Array.wrap(caller)[0]\} one of \#\{#{plural_enum_name}.keys.inspect\} expected"
            )
          end
        RUBY
      end
    end

    # @api public
    module ClassMethods
      def ordered_enum(enum_name)
        Generator.new(klass: self, enum_name: enum_name).generate
      end
    end
  end
end
