# frozen_string_literal: true
require 'active_model_authorization/concern/class_methods'
require 'active_model_authorization/concern/instance_methods'

module ActiveModelAuthorization
  module Concern
    def self.included(klass)
      klass.extend ClassMethods
      klass.include InstanceMethods
    end
  end
end
