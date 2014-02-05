class ProjectPackage
  include MongoMapper::Document
  key :version, String

  belongs_to :project
  belongs_to :package

  def updated?
    Gem::Version.new(version) >= Gem::Version.new(self.package.version) rescue true
  end

  def as_json(options = {})
    {
      name: package.name,
      version: self.version,
      system: package.package_system.name,
      updated: self.updated?
    }
  end
end
