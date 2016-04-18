# frozen_string_literal: true
require 'active_model_authorization/concern/class_methods'
require 'active_model_authorization/concern/instance_methods'
require 'active_model_authorization/authorization_file_preloader'

module ActiveModelAuthorization
  module Concern
    def self.included(klass)
      klass.extend ClassMethods
      klass.include InstanceMethods
      AuthorizationFilePreloader.preload
    end
  end
end
