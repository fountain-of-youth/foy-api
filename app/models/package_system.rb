class PackageSystem
  include MongoMapper::Document
  key :name, String

  validates_uniqueness_of :name

  many :packages

  def update_packages! packages_data
    packages_data.each do |data|
      update_package! data
    end
  end

  def update_package! data
    package = packages.find_or_create_by_name(data[:name])
    package.version = data[:version]
    package.save!
  end
end
