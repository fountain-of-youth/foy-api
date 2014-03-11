class ProjectPackage
  include MongoMapper::Document
  key :version, String

  belongs_to :project
  belongs_to :package

  def updated?
    Gem::Version.new(version) >= Gem::Version.new(self.package.version) rescue nil
  end

  def as_json(options = {})
    super(options).tap do |attrs|
      attrs[:status]  = updated? ? 'updated' : 'outdated'
      attrs[:system]  = package.package_system.name
      attrs[:name]    = package.name
    end
  end
end
