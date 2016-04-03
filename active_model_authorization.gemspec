# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_model_authorization/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_model_authorization'
  spec.version       = ActiveModelAuthorization::VERSION
  spec.authors       = ['Marek L']
  spec.email         = ['nospam.keram@gmail.com']

  spec.summary       = 'Active Model Authorization library'
  spec.description   = 'Simple authorizations for our active models'
  spec.homepage      = 'http://github.com/keram/active_model_authorization'

  spec.metadata['allowed_push_host'] = 'TODO: Set to http://mygemserver.com'

  spec.files = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/})
  }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.12.a'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'simplecov', '~> 0.11'
  spec.add_development_dependency 'byebug', '~> 8.2'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1'
end
