require 'grape'
require_relative 'models'
require_relative 'api/packages'
require_relative 'api/projects'

module Freshdated
  class Root < Grape::API
    default_format :json
    version 'v1'

    rescue_from MongoMapper::DocumentNotFound do |e|
      error_response message: 'Not Found', status: 404
    end
    
    mount Freshdated::API::Packages
    mount Freshdated::API::Projects
  end
end
