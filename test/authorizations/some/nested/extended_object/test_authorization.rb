# frozen_string_literal: true
module ActiveModelAuthorization
  module Authorizations
    module Some
      module Nested
        module ExtendedObject
          class TestAuthorization < Authorization
            def can_make_a_tea?
              true
            end
          end
        end
      end
    end
  end
end
