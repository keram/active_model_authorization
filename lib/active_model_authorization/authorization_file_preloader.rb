# frozen_string_literal: true
module ActiveModelAuthorization
  module AuthorizationFilePreloader
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
      .each do |path|
        Dir.glob(path).each { |file| require(file) }
      end
  end
end
