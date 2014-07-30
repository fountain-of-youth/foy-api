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
      let(:system) do
        double(:system, update_packages!: nil)
      end

      let(:data) do
        {packages: [{name: 'rest-client', version: '1.0.1'}]}
      end
      
      context "package system not found" do
        before do
          allow(PackageSystem).to receive(:find_by_name!)
            .and_raise(MongoMapper::DocumentNotFound)
          put "/v1/packages/pip.json", data
        end

        it "returns 404" do
          expect(last_response.status).to eq(404)
        end

        it "doesn't update the packages" do
          expect(system).to_not have_received(:update_packages!)
        end
      end

      context "package system found" do
        before do
          allow(PackageSystem).to receive(:find_by_name!).and_return(system)
          put "/v1/packages/pip.json", data
        end

        it "updates the packages" do
          expect(system).to have_received(:update_packages!).with(data[:packages])
        end
        
        it "returns 200" do
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end
