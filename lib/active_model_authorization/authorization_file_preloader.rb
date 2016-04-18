# frozen_string_literal: true
module ActiveModelAuthorization
  module AuthorizationFilePreloader
    def self.preload
      $LOAD_PATH
        .select do |path|
          Dir.exist? File.join(path,
                               'authorizations')
        end
        .map do |path|
          File.join(path,
                    'authorizations',
                    '**',
                    '*authorization.rb')
        end
        .flat_map do |path|
          Dir.glob(path)
        end
        .each do |file|
          require(file)
        end
    end
  end
end
