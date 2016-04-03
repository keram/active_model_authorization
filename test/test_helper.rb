# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'test'
    command_name 'Minitest'
  end
end

require 'active_model_authorization'

require 'minitest/autorun'
require 'minitest/reporters'
require 'byebug'

module Minitest
  Reporters.use! [Reporters::DefaultReporter.new(color: true)]
end
