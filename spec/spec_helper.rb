ENV['RACK_ENV'] ||= 'test'

require 'byebug'
require 'rack/test'
require 'database_cleaner'
require 'factory_girl'
FactoryGirl.find_definitions

require File.expand_path("../../environment", __FILE__)

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.include FactoryGirl::Syntax::Methods

  DatabaseCleaner.orm = "mongoid"
  DatabaseCleaner.strategy = :truncation

  config.before(:each) do
    DatabaseCleaner.clean
  end
end
