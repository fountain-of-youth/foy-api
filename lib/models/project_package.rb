class ProjectPackage
  include MongoMapper::Document
  key :version, String

  belongs_to :project
  belongs_to :package

  def updated?
    Gem::Version.new(version) >= Gem::Version.new(self.package.version) rescue true
  end
end
