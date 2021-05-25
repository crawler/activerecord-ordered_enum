# frozen_string_literal: true

require 'active_support/concern'

module ActiveRecord
  module OrderedEnum
    autoload :VERSION, 'activerecord/ordered_enum/version'
    extend ActiveSupport::Concern

    module ClassMethods
      def ordered_enum(name)
        plural_name = name.to_s.pluralize
        # TODO: desired validation
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}_exactly?(desired) # def state_exactly?(desired)
            #{name} == desired.to_s     #   state == desired.to_s
          end                           # end

          def #{name}_to?(desired, exclusive: false) # def state_to?(desired, exclusive: false)
            self.class.#{plural_name}_to(            #   self.class.states_to(
              desired, exclusive: exclusive          #     desired, exclusive: exclusive
            ).include?(#{name}.to_s)                 #   ).include?(state.to_s)
          end                                        # end

          # e.g. order.state_from? 'played'
          def #{name}_from?(desired, exclusive: false)
            self.class.#{plural_name}_from(desired, exclusive: exclusive).include?(#{name}.to_s)
          end

          class << self
            # e.g. Order.states_to 'payment'
            def #{plural_name}_to(desired, exclusive: false)
              #{plural_name}.keys[..(#{name}_index(desired) - (exclusive ? 1 : 0))]
            end

            # e.g. Order.states_from 'paid'
            def #{plural_name}_from(desired, exclusive: false)
              #{plural_name}.keys[(#{name}_index(desired) + (exclusive ? 1 : 0))..]
            end

            def #{name}_index(desired)
              #{plural_name}.keys.index(desired.to_s).tap do |index|
                raise_invalid_desired_#{name}(desired) if index.nil?
              end
            end

            # e.g. scope Order.state_from('placed')
            def #{name}_from(desired, exclusive: false)
              where(#{name}: #{plural_name}_from(desired, exclusive: false))
            end

            # e.g. scope Order.state_to('placed')
            def #{name}_to(desired, exclusive: false)
              where(#{name}: #{plural_name}_to(desired, exclusive: exclusive))
            end

            # e.g. scope Order.state('placed')
            def #{name}(desired, exclusive: false)
              where(#{name}: desired)
            end

            protected

            def raise_invalid_desired_#{name}(desired)
              raise(
                ArgumentError,
                "Invalid desired \\"\#\{desired\}\\" argument passed to " \
                "\#\{Array.wrap(caller)[0]\} one of \#\{#{plural_name}.keys.inspect\} expected"
              )
            end
          end
        RUBY
      end
    end
  end
end
