# frozen_string_literal: true
require 'test_helper'
require 'authorizations/concerned_object/test_authorization'

module ActiveModelAuthorization
  class AuthorizationInstanceFactoryTest < Minitest::Test
    def test_authorization_class
      factory = AuthorizationInstanceFactory.new(ConcernedObject,
                                                 ConcernedObject,
                                                 nil)
      assert_equal Authorizations::ConcernedObject::TestAuthorization,
                   factory.authorization_class('TestAuthorization')
    end

    def test_authorization_class_sub_object
      factory = AuthorizationInstanceFactory.new(ConcernedSubObject,
                                                 ConcernedSubObject,
                                                 nil)
      assert_equal Authorizations::ConcernedObject::TestAuthorization,
                   factory.authorization_class('TestAuthorization')
    end

    def test_authorization_class_sub_object_non_existing
      factory = AuthorizationInstanceFactory.new(ConcernedSubObject,
                                                 ConcernedSubObject,
                                                 nil)
      assert_equal Authorization,
                   factory.authorization_class('AdminAuthorization')
    end

    def test_build
      factory = AuthorizationInstanceFactory.new(ConcernedSubObject,
                                                 ConcernedSubObject,
                                                 nil)
      assert_instance_of Authorizations::ConcernedObject::TestAuthorization,
                         factory.build('Test')
    end
  end
end
