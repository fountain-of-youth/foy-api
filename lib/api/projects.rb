module Freshdated
  module API
    class Projects < Grape::API
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
          Project.find!(params[:id])
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
            desc "List packages of a project"
            params do
              requires :project_id, type: String, desc: "Project ID"
            end
            get do
              Project.find!(params[:project_id]).project_packages
            end
            desc "Register packages of a project"
            params do
              requires :project_id, type: String, desc: "Project ID"
              requires :system,     type: String, desc: "Package system"
              requires :packages,   type: Array,  desc: "List of packages"
            end
            put do
              project = Project.find!(params[:project_id])
              package_system = PackageSystem.find_by_name! params[:system]
              project.update_packages_for! package_system, params[:packages]
            end
          end
        end
      end
    end
  end
end
