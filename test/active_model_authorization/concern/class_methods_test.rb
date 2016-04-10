# frozen_string_literal: true
require 'test_helper'

module ActiveModelAuthorization
  module Concern
    class ClassMethodsTest < Minitest::Test
      def subject
        ExtendedObject
      end

      def subject_humanized
        'extended objects'
      end

      def subject_without_authorization_request_role
        ExtendedWithoutRequesterRoleObject
      end

      def subject_without_authorization_request_role_class_name
        ExtendedWithoutRequesterRoleObject.name
      end

      def subject_with_namespace
        Some::Nested::ExtendedObject
      end

      def authorized_action
        'make_a_tea'
      end

      def prohibited_action
        'have_a_cake'
      end

      def test_extended_object_respond_to_authorize
        assert subject.respond_to?(:authorize!)
      end

      def test_without_role_implementation_raises_exception
        assert_raises(NotImplemented) do
          subject_without_authorization_request_role
            .authorize!(nil, authorized_action)
        end
      end

      def test_not_implemented_exception_message
        subject_without_authorization_request_role
          .authorize!(nil, authorized_action)
      rescue NotImplemented => error
        assert_equal(
          'The method `authorization_requester_role` must be implemented in ' +
           subject_without_authorization_request_role_class_name,
          error.message)
      end

      def test_authorize_bang_prohibited_action
        assert_raises(AccessDenied) do
          subject.authorize!(nil, prohibited_action)
        end
      end

      def test_authorize_bang_prohibited_action_message
        subject.authorize!(nil, prohibited_action)
      rescue AccessDenied => error
        expected = "Nil class can not #{prohibited_action} #{subject_humanized}"
        assert_equal expected, error.message
      end

      def test_authorize_bang_authorized_action
        assert subject.authorize!(nil, authorized_action)
      end

      def test_namespaced_extended_object_authorize_bang_authorized_action
        assert subject_with_namespace.authorize!(1, authorized_action)
      end

      def test_namespaced_extended_object_authorize_bang_prohibited_action
        assert_raises(AccessDenied) do
          subject_with_namespace.authorize!(1, prohibited_action)
        end
      end

      def test_authorize_authorized_action
        assert subject.authorize(nil, authorized_action)
      end

      def test_authorize_prohibited_action
        refute subject.authorize(nil, prohibited_action)
      end

      def test_authorize_with_block_authorized_action
        success = subject.authorize_with_block(nil, authorized_action) do
          'Big Red Robe Tea'
        end

        assert_equal 'Big Red Robe Tea', success
      end

      def test_authorize_with_block_prohibited_action
        failure = subject.authorize_with_block(nil, prohibited_action) do
          'Chocolate Cake'
        end

        assert_equal nil, failure
      end
    end
  end
end
