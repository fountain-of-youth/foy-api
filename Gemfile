source "https://rubygems.org"

gem 'bson_ext'
gem 'grape'
gem 'mongo_mapper'
gem 'rack-cors'

group :test, :development do
  gem 'rspec'
  gem 'byebug'
end

group :test do
  gem "rack-test", require: "rack/test"
  gem "database_cleaner", require: false
  gem "factory_girl"
end

group :development do
  gem 'foreman'
end
