FactoryGirl.define do
  sequence(:id) {|n| n }

  factory :project do
    title {"Projeto #{generate(:id)}"}
    repository {"git://example#{id}"}
  end

  factory :package_system do
    name 'gem'
  end
end
