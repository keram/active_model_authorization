# frozen_string_literal: true
require 'test_helper'

module ActiveModelAuthorization
  class ConcernTest < Minitest::Test
    def test_included_object_respond_to_authorize
      instance = ConcernedObject.new
      assert instance.respond_to?(:authorize!)
    end

    def test_authorize_bang_with_role_implementation_raise_access_denied
      instance = ConcernedObject.new

      requester = nil
      assert_raises(AccessDenied) do
        instance.authorize!(requester, prohibited_action)
      end
    end

    def test_authorize_bang_with_role_on_subclass
      instance = ConcernedSubObject.new

      requester = nil

      assert_raises(AccessDenied) do
        instance.authorize!(requester, prohibited_action)
      end
    end

    # def test_that_it_can_make_tea
    #   object = ConcernedObject.new

    #   requester = nil

    #   assert object.authorize!(requester, authorized_action)
    # end

    # def test_inherited_concern
    # end

    def authorized_action
      'make_a_tea'
    end

    def prohibited_action
      'have_a_cake'
    end
  end
end
