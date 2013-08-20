Bundler.setup :default, (ENV['RACK_ENV'] || 'development')

require 'mongoid'
Mongoid.load!("mongoid.yml")

require_relative 'lib/foy_api'
