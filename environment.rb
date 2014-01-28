require 'rubygems'
require 'bundler'

ENV['RACK_ENV'] ||= 'development'

Bundler.setup :default, ENV['RACK_ENV'].to_sym
Bundler.require :default, ENV['RACK_ENV'].to_sym

require 'mongo_mapper'

mongo_uri = if ENV['MONGO_URI']
  #mongodb://[username:password@]host1[:port1]
  "mongodb://#{ENV['MONGO_USER']}:#{ENV['MONGO_PASSWORD']}@#{ENV['MONGO_URI']}/#{ENV['MONGO_DATABASE_NAME']}"
else
  "mongodb://localhost/foy_#{ENV['RACK_ENV']}"
end

MongoMapper.setup({ENV['RACK_ENV'] => {'uri' => mongo_uri}}, ENV['RACK_ENV'])

require_relative 'lib/foy_api'
