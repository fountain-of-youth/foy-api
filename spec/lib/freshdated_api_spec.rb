require 'spec_helper'

describe Freshdated::API do
  include Rack::Test::Methods

  def app
    Freshdated::API
  end

  describe "packages" do
    let!(:system) do
      FactoryGirl.create(:package_system, name: 'pip')
    end

    let!(:other_system) do
      FactoryGirl.create(:package_system, name: 'gem')
    end

    describe "GET /v1/packages/:system.json" do
      let!(:other_packages) do
        FactoryGirl.create_list(:package, 3, package_system: other_system)
      end

      let!(:packages) do
        FactoryGirl.create_list(:package, 3, package_system: system)
      end

      it "returns all packages of a system" do
        get "/v1/packages/pip.json"
        expect(last_response.body).to eq(packages.to_json)
      end

      it "returns only name and version for each package" do
        get "/v1/packages/pip.json"
        returned_packages = JSON.parse(last_response.body)
        returned_packages.each do |pkg|
          expect(pkg.keys).to eq(['name', 'version'])
        end
      end

      context "package system not found" do
        it "returns 404" do
          get '/v1/packages/xyz.json'
          expect(last_response.status).to eq(404)
        end
      end
    end

    describe "PUT /v1/packages/:system.json" do
      let!(:other_packages) do
        FactoryGirl.create_list(:package, 3, package_system: system)
      end

      context "package system not found" do
        let(:data) do
          {packages: [{name: 'rest-client', version: '1.0.1'}]}
        end

        it "returns 404" do
          put '/v1/packages/xyz.json', data
          expect(last_response.status).to eq(404)
        end
      end

      context "new packages" do
        let(:data) do
          {packages: [{name: 'rest-client', version: '1.0.1'}, {name: 'rspec', version: '2.0.0'}]}
        end

        it "creates nonexistent packages" do
          put "/v1/packages/#{system.name}.json", data
          expect(system.packages.first(name: 'rest-client')).to_not be_nil
          expect(system.packages.first(name: 'rspec')).to_not be_nil
          expect(system.packages.count).to eq(5)
        end
      end

      context "updating packages" do
        let!(:current_packages) do
          FactoryGirl.create_list(:package, 3, package_system: system)
        end

        let(:package) do
          other_packages.first
        end

        let(:data) do
          {packages: [{name: package.name, version: package.version}]}
        end

        let(:put_data) do
          put "/v1/packages/#{system.name}.json", data
        end

        it "doesn't udpate number of packages" do
          expect{put_data}.to_not change{Package.count}.from(6)
        end
    
        it "doesn't updates package" do
          expect{put_data}.to_not change{Package.all}
        end
      end
    end
  end

  describe "projects" do
    let!(:projects) do
      FactoryGirl.create_list(:project, 3)
    end
    let!(:project) do
      projects.last
    end

    describe "GET /v1/projects.json" do
      it "returns all projects" do
        get "/v1/projects.json"
        expect(last_response.body).to eq(projects.to_json)
      end
    end

    describe "GET /v1/projects/:id.json" do
      let(:valid_id) { project.id }
      it "returns specified project" do
        get "/v1/projects/#{valid_id}.json"
        expect(last_response.body).to eq(project.to_json)
      end

      context "project not found" do
        let(:not_found_id) { "invalid" }
        it "returns 404" do
          get "/v1/projects/#{not_found_id}.json"
          expect(last_response.status).to eq(404)
        end
      end
    end

    describe "POST /v1/projects" do
      let(:post_data) do
        post "/v1/projects", data
      end

      context "valid data" do
        let(:data) {{title: "New Project", repository:  "New Repository"}}

        it "increments number of projects" do
          expect{ post_data }.to change{ Project.count }.from(3).to(4)
        end

        it "adds new project" do
          expect{ post_data }.to change{ Project.all.last.title }.from(Project.all.last.title).to("New Project")
        end

        it "returns status 201" do
          post_data
          expect(last_response.status).to eq(201)
        end
      end

      context "invalid data" do
        let(:data) {{title: 'Test'}}

        it "returns status 400" do
          post_data
          expect(last_response.status).to eq(400)
        end

        it "returns error message" do
          post_data
          expect(last_response.body).to eq({"error" => "repository is missing"}.to_json)
        end
      end
    end
  end

  describe "projects/packages" do
    let!(:project)          { FactoryGirl.create(:project) }
    let!(:package_system)   { FactoryGirl.create(:package_system) }
    let!(:current_packages) { FactoryGirl.create_list(:package, 2, package_system: package_system) }

    describe "GET /v1/projects/:id/packages" do
      let!(:project_packages) { FactoryGirl.create_list(:project_package, 2, project: project, package: FactoryGirl.create(:package, {package_system: package_system})) }
      let(:get_data)          { get "/v1/projects/#{project.id}/packages" }

      it "returns status 200" do
        get_data
        expect(last_response.status).to eq(200)
      end

      it "returns project packages" do
        get_data
        returned_packages = JSON.parse(last_response.body)
        expect(returned_packages.size).to eq(2)
        returned_packages.each do |pkg|
          expect(pkg.keys).to eq(["id", "package_id", "project_id", "version", "status", "system", "name", "last_version"])
        end
      end
    end

    describe "PUT /v1/projects/:id/packages" do
      let(:put_data)          { put "/v1/projects/#{project.id}/packages", data }

      context "new packages" do
        let(:data) do
          {system: package_system.name, packages: [{name: 'rest-client', version: '1.0.1'}, {name: 'rspec', version: '2.0.0'}]}
        end

        it "associates project with its packages" do
          put_data
          expect(project.packages).to include(Package.first(name: 'rest-client'))
          expect(project.packages).to include(Package.first(name: 'rspec'))
        end

        it "creates nonexistent packages" do
          put_data
          expect(package_system.packages.first(name: 'rest-client')).to_not be_nil
          expect(package_system.packages.first(name: 'rspec')).to_not be_nil
          expect(package_system.packages.count).to be ==(4)
        end
      end

      context "existing packages" do
        let(:data) do
          {system: package_system.name, packages: current_packages.collect{|pkg| {name: pkg.name, version: '2.0.0'}}}
        end

        it "updates current project packages" do
          expect{put_data}.to change{project.reload; project.packages}.from([]).to(current_packages)
        end
    
        it "doesn't updates package" do
          expect{put_data}.to_not change{Package.all}
        end
      end
    end
  end
end
