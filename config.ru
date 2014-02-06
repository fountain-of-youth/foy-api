require 'environment'

file = File.new("log/#{ENV['APP_ENV']}.log", 'a+')
file.sync = true
use Rack::CommonLogger, file

run Foy::API
