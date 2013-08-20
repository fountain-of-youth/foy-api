Bundler.setup :default, (ENV['RACK_ENV'] || 'development')

require 'mongo_mapper'

mongo_uri = if ENV['MONGO_URI']
  #mongodb://[username:password@]host1[:port1]
  "mongodb://#{ENV['MONGO_USER']}:#{ENV['MONGO_PASSWORD']}@#{ENV['MONGO_URI']}"
else
  'mongodb://localhost/foy'
end

MongoMapper.setup({ENV['RACK_ENV'] => {'uri' => mongo_uri}}, ENV['RACK_ENV'])

require_relative 'lib/foy_api'
