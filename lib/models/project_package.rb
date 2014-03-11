class ProjectPackage
  include MongoMapper::Document
  key :version, String

  belongs_to :project
  belongs_to :package

  def updated?
    Gem::Version.new(version) >= Gem::Version.new(self.package.version) rescue nil
  end

  def status
    return nil if last_version.nil?
    updated? ? 'updated' : 'outdated'
  end

  def last_version
    package.version
  end

  def as_json(options = {})
    super(options).tap do |attrs|
      attrs[:status]  = status
      attrs[:system]  = package.package_system.name
      attrs[:name]    = package.name
      attrs[:last_version] = package.version
    end
  end
end
