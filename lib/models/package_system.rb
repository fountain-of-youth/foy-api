class PackageSystem
  include MongoMapper::Document
  key :name, String

  validates_uniqueness_of :name

  many :packages

  def update_packages! packages_data
    packages_data.each do |package_data|
      package = packages.find_or_create_by_name(package_data[:name])
      package.version = package_data[:version]
      package.save!
    end
  end
end
