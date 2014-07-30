class Project
  include MongoMapper::Document
  key :title, String
  key :repository, String

  many :project_packages

  def packages
    self.project_packages.collect(&:package)
  end

  def updated?
    self.project_packages.all? do |package|
      package.updated?
    end
  end

  def outdated_packages
    self.project_packages.select do |package|
      not package.updated?
    end
  end

  def update_packages_for! system, package_data
    package_data.each do |data|
      package = system.packages.find_or_create_by_name(data[:name])
      update_package! package, data
    end
  end

  def update_package! package, data
    project_package = project_packages.find_or_create_by_package_id(package.id)
    project_package.version = data[:version]
    project_package.save!
  end

  def as_json options = {}
    super(options).tap do |attrs|
      attrs[:status] = updated? ? 'updated' : 'outdated'
    end
  end
end
