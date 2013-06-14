class Project
  include MongoMapper::Document
  key :title, String
  key :repository, String

  many :project_packages
  belongs_to :handler

  def packages
    self.project_packages
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