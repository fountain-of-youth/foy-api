require 'environment'
require 'rack/cors'

file = File.new("log/#{ENV['APP_ENV']}.log", 'a+')
file.sync = true
use Rack::CommonLogger, file
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

run Freshdated::API
