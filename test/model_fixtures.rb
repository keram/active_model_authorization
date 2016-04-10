# frozen_string_literal: true
class ExtendedObject
  extend ActiveModelAuthorization::Concern::ClassMethods

  def self.authorization_requester_role(*)
    'Test'
  end
end

class ExtendedWithoutRequesterRoleObject
  extend ActiveModelAuthorization::Concern::ClassMethods
end

module Some
  module Nested
    class ExtendedObject
      extend ActiveModelAuthorization::Concern::ClassMethods

      def self.authorization_requester_role(*)
        'Test'
      end
    end
  end
end

class IncludedObject
  include ActiveModelAuthorization::Concern::InstanceMethods

  def authorization_requester_role(*)
    'Test'
  end
end

class IncludedWithoutRequesterRoleObject
  include ActiveModelAuthorization::Concern::InstanceMethods
end

module Some
  module Nested
    class IncludedObject
      include ActiveModelAuthorization::Concern::InstanceMethods

      def authorization_requester_role(*)
        'Test'
      end
    end
  end
end

class ConcernedObject
  include ActiveModelAuthorization::Concern

  def self.authorization_requester_role(*)
    'Test'
  end

  def authorization_requester_role(*)
    'Test'
  end
end

class ConcernedSubObject < ConcernedObject
end
