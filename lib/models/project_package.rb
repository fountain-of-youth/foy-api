class ProjectPackage
  include Mongoid::Document
  store_in collection: :project_packages
  
  field :version, type: String
  field :system,  type: String

  belongs_to :project
  belongs_to :package

  def updated?
    Gem::Version.new(version) >= Gem::Version.new(self.package.version) rescue true
  end
end
