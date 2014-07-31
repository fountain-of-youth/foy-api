class Package
  include MongoMapper::Document
  key :name, String
  key :version, String

  many :project_packages
  belongs_to :package_system

  def as_json(options = {})
    {
      name: self.name,
      version: self.version
    }
  end
end
