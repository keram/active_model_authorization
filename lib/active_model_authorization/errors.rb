# frozen_string_literal: true
module ActiveModelAuthorization
  class Error < StandardError; end
  class AccessDenied < Error; end
  class NotImplemented < Error; end
end
