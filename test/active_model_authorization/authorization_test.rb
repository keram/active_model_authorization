# frozen_string_literal: true
require 'test_helper'

module ActiveModelAuthorization
  class AuthorizationTest < Minitest::Test
    # initialize(requester, sender, sender_class_name)
    def test_initialization
      authorization = Authorization.new(nil, nil, nil)

      assert_instance_of Authorization, authorization
    end

    def test_authorize_prohibited_action
      authorization = Authorization.new(nil, nil, nil)

      refute authorization.authorize(prohibited_action)
    end

    def test_authorize_with_bang_prohibited_action
      assert_raises(AccessDenied) do
        authorization_instance.authorize!(prohibited_action)
      end
    end

    def test_authorize_with_bang_prohibited_action_exception_message
      authorization_instance.authorize!(prohibited_action)

    rescue AccessDenied => exception
      sender_human_name = sender_name.underscore.humanize.downcase
      requester_name = requester.class.name
      assert_equal(
        "#{requester_name} can not #{prohibited_action} #{sender_human_name}",
        exception.message)
    end

    def test_authorize_authorized_action?
      authorization = authorization_instance

      authorization.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def can_#{authorized_action}?
          true
        end
      RUBY

      assert authorization.authorize(authorized_action)
    end

    def test_authorize_with_block_authorized_action
      authorization = authorization_instance

      authorization.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def can_#{authorized_action}?
          true
        end
      RUBY

      success = authorization.authorize_with_block(authorized_action) do
        'Big Red Robe Tea'
      end

      assert_equal 'Big Red Robe Tea', success
    end

    def test_authorize_with_block_prohibited_action
      failure =
        authorization_instance.authorize_with_block(prohibited_action) do
          'Chocolate Cake'
        end

      assert_equal nil, failure
    end

    def test_undefined_method_raise_exception
      assert_raises(NoMethodError) do
        authorization_instance.undefined_method
      end
    end

    def authorization_instance
      Authorization.new(requester, sender,
                        AccessDeniedMessage.new(requester.class.name,
                                                sender_name))
    end

    def requester
      1
    end

    def sender
      nil
    end

    def sender_name
      'SomeName'
    end

    def authorized_action
      'make_a_tea'
    end

    def prohibited_action
      'have_a_cake'
    end
  end
end
