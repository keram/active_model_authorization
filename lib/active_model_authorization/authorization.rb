# frozen_string_literal: true
module ActiveModelAuthorization
  class Authorization
    DEFAULT_STATUS = false
    CHECK_METHOD_REGEXP = /\Acan_[a-z]+[a-z_]+[^_]\?\z/

    def initialize(requester, sender, access_denied_message)
      @requester = requester
      @sender = sender
      @access_denied_message = access_denied_message
    end

    def authorize(message_name)
      send("can_#{message_name}?")
    end

    def authorize_with_block(action_name, &block)
      {
        true => block,
        false => -> { false }
      }[authorize(action_name)].call
    end

    def authorize!(message_name)
      authorized = authorize(message_name)

      send("dispatch_authorized_#{authorized}", message_name)
    end

    private

    attr_reader :requester, :sender, :access_denied_message

    def dispatch_authorized_true(*)
      true
    end

    def dispatch_authorized_false(message_name)
      raise AccessDenied, access_denied_message.generate(message_name)
    end

    def default_status
      self.class::DEFAULT_STATUS
    end

    def authorization_check_method?(method_name)
      method_name.match(CHECK_METHOD_REGEXP) == 0
    end

    def method_missing(method_name, *arguments, &block)
      { true => proc { return default_status },
        false => -> {}
      }[authorization_check_method?(method_name)].call

      super
    end
  end
end
