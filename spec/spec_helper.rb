ENV['RACK_ENV'] ||= 'test'

require 'rack/test'
require 'database_cleaner'

require File.expand_path("../../environment", __FILE__)


RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
