# frozen_string_literal: true
require 'active_support/core_ext/string/inflections'

module ActiveModelAuthorization
  class AuthorizationInstanceFactory
    NOT_IMPLEMENTED_AUTHORIZATION_REQUESTER_ROLE_MESSAGE_PREFIX =
      'The method `authorization_requester_role` must be implemented in '

    attr_reader :sender, :sender_class,
                :access_denied_message

    def initialize(sender, sender_class, access_denied_message)
      @sender = sender
      @sender_class = sender_class
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

    def authorization_requester_role(requester)
      sender.send(:authorization_requester_role, requester)

    rescue NoMethodError
      raise NotImplemented,
            NOT_IMPLEMENTED_AUTHORIZATION_REQUESTER_ROLE_MESSAGE_PREFIX +
            sender_class.name
    end

    def authorization_class(authorization_class_name)
      ancestors(sender_class).each do |ancestor|
        begin
          return Authorizations.module_eval(ancestor.name +
                                            '::' +
                                            authorization_class_name)
        rescue NameError
          next
        end
      end

      Authorization
    end

    def authorization_class_name(role)
      "#{role}Authorization"
    end

    def ancestors(sender_class)
      sender_class
        .ancestors
        .select { |ancestor| ancestor.is_a? Class }
        .reject { |ancestor| [Object, BasicObject].include? ancestor }
    end
  end
end
