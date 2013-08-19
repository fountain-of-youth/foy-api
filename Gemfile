source "https://rubygems.org"

gem 'bson_ext'
gem 'grape'
gem 'builder', '2.1.2'
gem 'mongo_mapper', git: 'git://github.com/jnunemaker/mongomapper.git'


group :test, :development do
  gem 'rspec'
end

group :test do
  gem "rack-test", require: "rack/test"
  gem "database_cleaner", require: "false"
  gem "factory_girl"
end
