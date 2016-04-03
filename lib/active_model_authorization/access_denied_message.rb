# frozen_string_literal: true
require 'active_support/core_ext/string/inflections'

module ActiveModelAuthorization
  class AccessDeniedMessage
    attr_reader :requester_name, :sender_name

    def initialize(requester_class_name, sender_class_name)
      @requester_name = requester_class_name.underscore.humanize
      @sender_name = sender_class_name.underscore.humanize(capitalize: false)
    end

    def generate(message_name)
      "#{requester_name} can not #{message_name} #{sender_name}"
    end
  end
end
