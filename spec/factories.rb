FactoryGirl.define do
  sequence(:id) {|n| n }

  factory :project do
    title {"Projeto #{generate(:id)}"}
    repository {"git://example#{id}"}
  end

  factory :package_system do
    name 'gem'
  end

  factory :package do
    name { "pkg #{generate(:id)}" }
    version '3.0.0'
    package_system 
  end

  factory :project_package do
    project
    package
    version '2.0.0'
  end
end
