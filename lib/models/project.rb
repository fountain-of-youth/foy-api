class Project
  include Mongoid::Document
  store_in collection: :projects
  field :title, type: String
  field :repository, type: String
  
  has_many :project_packages

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
end
