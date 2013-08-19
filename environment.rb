Bundler.setup :default, (ENV['RACK_ENV'] || 'development')

require 'mongo_mapper'

mongo_uri = ENV['MONGO_URI'] || 'mongodb://localhost/foy'

MongoMapper.setup({ENV['RACK_ENV'] => {'uri' => mongo_uri}}, ENV['RACK_ENV'])

require_relative 'lib/foy_api'
