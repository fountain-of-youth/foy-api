require 'spec_helper'

describe Freshdated::API::Packages do
  include Rack::Test::Methods

  def app
    Freshdated::API::Packages
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
end
