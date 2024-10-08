ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'sidekiq/testing'
require 'rspec-sidekiq'
require 'fileutils'
require_relative '../src/database'
require_relative '../app'

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include RSpec::Sidekiq::Matchers
  Sidekiq::Testing.fake!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.backtrace_exclusion_patterns = [/gems/]

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
