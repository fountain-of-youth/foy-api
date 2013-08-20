require 'grape'
require 'models'

module Foy
  class API < Grape::API
    default_format :json
    version 'v1'

    resources :projects do
      desc "Return all projects"
      get do
        Project.all
      end
      
      desc "Return a project"
      params do
        requires :id, type: String, desc: "Project ID"
      end
      get ':id' do
        begin
          Project.find_by(id: params[:id])
        rescue Mongoid::Errors::DocumentNotFound
          error! 'Not Found', 404
        end
      end

      desc "Create a project with title, repository"
      params do
        requires :title, type: String, desc: "Project title"
        requires :repository, type: String, desc: "Project repository"
      end
      post do
        Project.create(title: params[:title], repository: params[:repository])
      end

      segment '/:project_id' do
        resources :packages do
          desc "Register packages of a project"
          params do
            requires :project_id, type: String, desc: "Project ID"
            requires :system,     type: String, desc: "Project ID"
            requires :packages,   type: Array,  desc: "List of packages"
          end
          put do
            project = Project.find(params[:project_id])
            package_system = PackageSystem.find_by(name: params[:system])
            
            params[:packages].each do |param_package|
              package = package_system.packages.find_or_create_by(name: param_package[:name])
              project_package = project.project_packages.find_or_create_by(package: package)
              project_package.update_attributes!(version: param_package[:version])
            end
          end
        end
      end
    end
  end
end
