ENV['RACK_ENV'] ||= 'test'

require 'rack/test'
require 'database_cleaner'
require 'factory_girl'
FactoryGirl.find_definitions

require File.expand_path("../../environment", __FILE__)


RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.include FactoryGirl::Syntax::Methods

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
