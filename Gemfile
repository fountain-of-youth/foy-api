source "https://rubygems.org"

gem 'bson_ext'
gem 'grape'
gem 'mongoid', '~> 3.0.1'

group :test, :development do
  gem 'rspec'
  gem 'byebug'
end

group :development do
  gem 'foreman'
end

group :test do
  gem "rack-test", require: "rack/test"
  gem "database_cleaner", require: "false"
  gem "factory_girl"
end
