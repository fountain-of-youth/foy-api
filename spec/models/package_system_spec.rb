require 'spec_helper'

describe PackageSystem do
  describe "#update_packages!" do
    subject! do
      FactoryGirl.create(:package_system, name: 'pip')
    end

    let!(:other_system) do
      FactoryGirl.create(:package_system, name: 'gem')
    end

    let!(:other_packages) do
      FactoryGirl.create_list(:package, 3, package_system: subject)
    end

    let(:update_packages) do
      subject.update_packages! data
    end

    context "new packages" do
      let(:data) do
        [{name: 'rest-client', version: '1.0.1'}, {name: 'rspec', version: '2.0.0'}]
      end

      it "creates nonexistent packages" do
        update_packages
        expect(subject.packages.first(name: 'rest-client')).to_not be_nil
        expect(subject.packages.first(name: 'rspec')).to_not be_nil
        expect(subject.packages.count).to eq(5)
      end
    end

    context "updating packages" do
      let!(:current_packages) do
        FactoryGirl.create_list(:package, 3, package_system: subject)
      end

      let(:package) do
        other_packages.first
      end

      let(:data) do
        [{name: package.name, version: package.version}]
      end

      it "doesn't udpate number of packages" do
        expect{update_packages}.to_not change{Package.count}.from(6)
      end
  
      it "doesn't updates package" do
        expect{update_packages}.to_not change{Package.all}
      end
    end
  end
end
