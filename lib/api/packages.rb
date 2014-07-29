module Freshdated
  module API
    class Packages < Grape::API
      resources :packages do
        segment '/:system' do
          desc "Return all packages of a package system"
          get do
            begin
              package_system = PackageSystem.find_by_name!(params[:system])
              package_system.packages
            rescue MongoMapper::DocumentNotFound
              error! 'Not Found', 404
            end
          end

          desc "Update version of packages"
          params do
            requires :packages,   type: Array,  desc: "List of packages"
          end
          put do
            begin
              package_system = PackageSystem.find_by_name!(params[:system])
              params[:packages].each do |param_package|
                package = package_system.packages.find_or_create_by_name(param_package[:name])
                package.version = param_package[:version]
                package.save!
              end
            rescue MongoMapper::DocumentNotFound
              error! 'Not Found', 404
            end
          end
        end
      end
    end
  end
end
