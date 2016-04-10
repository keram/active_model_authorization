# frozen_string_literal: true
require 'test_helper'

module ActiveModelAuthorization
  class ConcernTest < Minitest::Test
    def test_included_object_respond_to_authorize
      instance = IncludedObject.new
      assert instance.respond_to?(:authorize!)
    end

    #  def authorize!(requester, action_name)
    def test_authorize_bang_without_role_implementation_raises_exception
      requester = nil
      action_name = 'something'
      instance = IncludedWithoutRequesterRoleObject.new

      assert_raises(NotImplemented) do
        instance.authorize!(requester, action_name)
      end
    end

    def test_not_implemented_exception_message
      instance = IncludedWithoutRequesterRoleObject.new
      instance.authorize!(nil, 'something')
    rescue NotImplemented => error
      assert_equal(
        'The method `authorization_requester_role` must be implemented in ' +
        IncludedWithoutRequesterRoleObject.name,
        error.message)
    end

    def test_authorize_bang_with_role_implementation_raise_access_denied
      instance = IncludedObject.new

      requester = nil
      action_name = 'something'

      assert_raises(AccessDenied) do
        instance.authorize!(requester, action_name)
      end
    end

    def test_that_it_can_make_tea
      object = IncludedObject.new

      requester = nil

      assert object.authorize!(requester, authorized_action)
    end

    def authorized_action
      'make_a_tea'
    end
  end
end
