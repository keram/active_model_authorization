# frozen_string_literal: true

module ActiveModelAuthorization
  module Concern
    module ClassMethods
      def authorize!(requester, action_name)
        authorization_instance_for(requester)
          .authorize!(action_name)
      end

      def authorize(requester, action_name)
        authorization_instance_for(requester)
          .authorize(action_name)
      end

      def authorize_with_block(requester, action_name, &block)
        authorization_instance_for(requester)
          .authorize_with_block(action_name, &block)
      end

      private

      def authorization_instance_for(requester)
        AuthorizationInstanceFactory
          .new(self,
               authorization_sender_class,
               authorization_access_denied_message(requester))
          .build(requester)
      end

      def authorization_sender_class
        self
      end

      def authorization_access_denied_message(requester)
        AccessDeniedMessage.new(requester.class.name,
                                authorization_sender_class.name.pluralize)
      end
    end
  end
end
