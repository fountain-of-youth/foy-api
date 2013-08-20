FactoryGirl.define do
  sequence(:id) {|n| n }

  factory :project do
    title {"Projeto #{generate(:id)}"}
    repository {"git://example#{id}"}
  end

  factory :package_system do
    name { "gem v#{generate(:id)}" }
    packages { build_list(:package, 2) }
  end

  factory :package do
    name { "pkg #{generate(:id)}" }
    version '3.0.0'
  end

  factory :project_package do
    version '1.0.0'
  end
end
