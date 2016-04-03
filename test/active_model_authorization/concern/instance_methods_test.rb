# frozen_string_literal: true
require 'test_helper'
require 'active_model_authorization/concern/class_methods_test'

class IncludedObject
  include ActiveModelAuthorization::Concern::InstanceMethods

  def authorization_requester_role(*)
    'Test'
  end
end

class IncludedWithoutRequesterRoleObject
  include ActiveModelAuthorization::Concern::InstanceMethods
end

module Some
  module Nested
    class IncludedObject
      include ActiveModelAuthorization::Concern::InstanceMethods

      def authorization_requester_role(*)
        'Test'
      end
    end
  end
end

module ActiveModelAuthorization
  module Concern
    class InstanceMethodsTest < ClassMethodsTest
      def subject
        IncludedObject.new
      end

      def subject_humanized
        'included object'
      end

      def subject_without_authorization_request_role
        IncludedWithoutRequesterRoleObject.new
      end

      def subject_without_authorization_request_role_class_name
        IncludedWithoutRequesterRoleObject.name
      end

      def subject_with_namespace
        Some::Nested::IncludedObject.new
      end
    end
  end
end
