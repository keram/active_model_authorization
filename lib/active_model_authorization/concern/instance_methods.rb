# frozen_string_literal: true

module ActiveModelAuthorization
  module Concern
    module InstanceMethods
      include ClassMethods

      private

      def authorization_sender_class
        self.class
      end

      def authorization_access_denied_message(requester)
        AccessDeniedMessage.new(requester.class.name,
                                authorization_sender_class.name)
      end
    end
  end
end
