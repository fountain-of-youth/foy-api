require 'spec_helper'

describe Project do
  describe "#update_packages_for!" do
    let!(:subject)          { FactoryGirl.create(:project) }
    let!(:package_system)   { FactoryGirl.create(:package_system) }
    let!(:current_packages) { FactoryGirl.create_list(:package, 2, package_system: package_system) }
    let(:packages_data) do
      [{name: 'rest-client', version: '1.0.1'}, {name: 'rspec', version: '2.0.0'}]
    end

    let(:update_packages) do
      subject.update_packages_for! package_system, packages_data
    end

    context "new packages" do
      before do
        update_packages
      end

      it "associates project with its packages" do
        expect(subject.packages).to include(Package.first(name: 'rest-client'))
        expect(subject.packages).to include(Package.first(name: 'rspec'))
      end

      it "creates nonexistent packages" do
        expect(package_system.packages.first(name: 'rest-client')).to_not be_nil
        expect(package_system.packages.first(name: 'rspec')).to_not be_nil
        expect(package_system.packages.count).to be ==(4)
      end
    end

    context "existing packages" do
      let(:packages_data) do
        current_packages.collect{|pkg| {name: pkg.name, version: '2.0.0'}}
      end

      it "updates current project packages" do
        expect{update_packages}.to change{subject.reload; subject.packages}.from([]).to(current_packages)
      end
  
      it "doesn't updates package" do
        expect{update_packages}.to_not change{Package.all}
      end
    end
  end
end
