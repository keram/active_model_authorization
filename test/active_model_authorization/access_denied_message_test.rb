# frozen_string_literal: true
require 'test_helper'

module ActiveModelAuthorization
  class AccessDeniedMessageTest < Minitest::Test
    def test_generate
      requester_class_name = 1.class.name
      sender_class_name = 'SomeName'
      message = AccessDeniedMessage.new(requester_class_name, sender_class_name)
      message_name = 'work'

      assert_equal(
        "#{requester_class_name} can not #{message_name} " +
        sender_class_name.underscore.humanize.downcase,
        message.generate(message_name))
    end
  end
end
