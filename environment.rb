Bundler.setup :default, (ENV['RACK_ENV'] || 'development')

require 'mongo_mapper'

MongoMapper.setup({ENV['RACK_ENV'] => {'uri' => 'mongodb://localhost/foy'}}, ENV['RACK_ENV'])

require_relative 'lib/foy_api'
