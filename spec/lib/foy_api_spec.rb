require 'spec_helper'

describe Foy::API do
  include Rack::Test::Methods

  def app
    Foy::API
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
        last_response.body.should == projects.to_json
      end
    end

    describe "GET /v1/projects/:id.json" do
      let(:valid_id) { project.id }
      it "returns specified project" do
        get "/v1/projects/#{valid_id}.json"
        last_response.body.should == project.to_json
      end

      context "project not found" do
        let(:not_found_id) { "invalid" }
        it "returns 404 when project is not found" do
          get "/v1/projects/#{not_found_id}.json"
          last_response.status.should == 404
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
          last_response.status.should == 201
        end
      end

      context "invalid data" do
        let(:data) {{title: 'Test'}}

        it "returns status 400" do
          post_data
          last_response.status.should == 400
        end

        it "returns error message" do
          post_data
          last_response.body.should == {"error" => "repository is missing"}.to_json
        end
      end
    end
  end

  describe "packages" do
    let!(:project)          { FactoryGirl.create(:project) }
    let!(:package_system)   { FactoryGirl.create(:package_system) }
    let!(:current_packages) { FactoryGirl.create_list(:package, 2, package_system: package_system) }
    let(:put_data)          { put "/v1/projects/#{project.id}/packages", packages }

    describe "PUT /v1/projects/:id/packages" do
      context "new packages" do
        let(:packages) do
          {system: package_system.name, packages: [{name: 'rest-client', version: '1.0.1'}, {name: 'rspec', version: '2.0.0'}]}
        end

        it "creates nonexistent packages" do
          put_data
          expect(Package.first(name: 'rest-client')).to_not be_nil
          expect(Package.first(name: 'rspec')).to_not be_nil
          expect(Package.count).to be_eql(4)
        end

        it "associates project with its packages" do
          put_data
          expect(project.packages).to include(Package.first(name: 'rest-client'))
          expect(project.packages).to include(Package.first(name: 'rspec'))
        end
      end

      context "existing packages" do
        let(:packages) do
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
