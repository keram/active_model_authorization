# frozen_string_literal: true
require 'active_support/core_ext/string/inflections'

module ActiveModelAuthorization
  class AuthorizationInstanceFactory
    NOT_IMPLEMENTED_AUTHORIZATION_REQUESTER_ROLE_MESSAGE_PREFIX =
      'The method `authorization_requester_role` must be implemented in '

    attr_reader :sender, :sender_class_name, :access_denied_message

    def initialize(sender, sender_class_name, access_denied_message)
      @sender = sender
      @sender_class_name = sender_class_name
      @access_denied_message = access_denied_message
    end

    def build(requester)
      authorization_class(
        authorization_class_name(
          authorization_requester_role(requester)
        )
      ).new(requester,
            sender,
            access_denied_message)
    end

    private

    def authorization_requester_role(requester)
      sender.send(:authorization_requester_role, requester)

    rescue NoMethodError
      raise NotImplemented,
            NOT_IMPLEMENTED_AUTHORIZATION_REQUESTER_ROLE_MESSAGE_PREFIX +
            sender_class_name
    end

    def authorization_class(authorization_class_name)
      require [
        'authorizations',
        sender_class_name.underscore,
        authorization_class_name.underscore
      ].join('/')

      Authorizations
        .const_get(sender_class_name)
        .const_get(authorization_class_name)
    end

    def authorization_class_name(role)
      "#{role}Authorization"
    end
  end
end
