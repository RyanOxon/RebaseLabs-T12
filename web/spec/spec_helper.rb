ENV['RACK_ENV'] = 'test'

require 'capybara/rspec'
require 'rspec'
require 'rack/test'
require_relative '../app'

def app
  Sinatra::Application
end

RSpec.configure do |config|
  Capybara.app = app

  config.include Capybara::DSL
  config.include Rack::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.backtrace_exclusion_patterns = [/gems/]

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
