require 'spec_helper'

describe Foy::API do

  include Rack::Test::Methods

  def app
    Foy::API
  end

  let(:project) { Project.new(title: "Project 1", repository: "http://git.example.globo.com") }

  describe "projects" do

    describe "GET /v1/projects.json" do
      it "returns all projects" do
        Project.should_receive(:all).and_return([project])
        get "/v1/projects.json"
        last_response.body.should == [project].to_json
      end
    end

    describe "GET /v1/projects/:id.json" do
      it "returns specified project" do
        Project.should_receive(:find!).with("123").and_return(project)
        get "/v1/projects/123.json"
        last_response.body.should == project.to_json
      end

      context "project not found" do
        it "returns 404 when project is not found" do
          get "/v1/projects/1234.json"
          last_response.status.should == 404
        end
      end
    end

    describe "POST /v1/projects" do

      context "valid data" do
        let(:valid_data) {{title: "Test", repository:  "test"}}

        it "creates a project" do
          Project.should_receive(:create).with(valid_data)
          post "/v1/projects", valid_data
          last_response.status.should == 201
        end
      end

      context "invalid data" do
        let(:invalid_data) {{title: 'Test'}}

        it "returns status 400" do
          post "/v1/projects", invalid_data 
          last_response.status.should == 400
        end

        it "returns error message" do
          post "/v1/projects", invalid_data 
          last_response.body.should == {"error" => "missing parameter: repository"}.to_json
        end
      end
    end
  end

  describe "packages" do

    describe "PUT /v1/projects/:id/packages" do
      let(:packages) do
        {system: "gem", packages: [{name: 'rest-client', version: '1.0.1'}, {name: 'rspec', version: '2.0.0'}]}
      end
      
      let!(:project) { Project.create(id: "321") }

      before do
        PackageSystem.create(name: "gem")
      end

      it "creates nonexistent packages " do
        Package.should_receive(:find_or_create_by_name).with('rest-client')
        Package.should_receive(:find_or_create_by_name).with('rspec')

        put "/v1/projects/321/packages", packages
      end

      it "registers packages per project" do
        ProjectPackage.should_receive(:find_or_create_by_name).with('rest-client')
        ProjectPackage.should_receive(:find_or_create_by_name).with('rspec')

        put "/v1/projects/321/packages", packages
      end
    end
  end
end
