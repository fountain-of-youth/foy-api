require 'rubygems'
require 'bundler'

ENV['APP_ENV'] ||= 'development'

Bundler.setup :default, ENV['APP_ENV'].to_sym
Bundler.require :default, ENV['APP_ENV'].to_sym

require 'mongo_mapper'

mongo_uri = if ENV['MONGO_URI']
  #mongodb://[username:password@]host1[:port1]
  "mongodb://#{ENV['MONGO_USER']}:#{ENV['MONGO_PASSWORD']}@#{ENV['MONGO_URI']}/#{ENV['MONGO_DATABASE_NAME']}"
else
  "mongodb://localhost/foy_#{ENV['APP_ENV']}"
end

MongoMapper.setup({ENV['APP_ENV'] => {'uri' => mongo_uri}}, ENV['APP_ENV'])

require_relative 'lib/foy_api'
