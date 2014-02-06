ENV['APP_ENV'] = 'test'
require File.expand_path("../../environment", __FILE__)

require 'rack/test'
require 'database_cleaner'
require 'factory_girl'
FactoryGirl.find_definitions


RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
