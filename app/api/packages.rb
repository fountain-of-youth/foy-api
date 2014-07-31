module Freshdated
  module API
    class Packages < Grape::API
      resources :packages do
        segment '/:system' do
          desc "Return all packages of a package system"
          get do
            package_system = PackageSystem.find_by_name!(params[:system])
            package_system.packages
          end

          desc "Update version of packages"
          params do
            requires :packages,   type: Array,  desc: "List of packages"
          end
          put do
            package_system = PackageSystem.find_by_name!(params[:system])
            package_system.update_packages!(params[:packages])
          end
        end
      end
    end
  end
end
