class PackageSystem
  include MongoMapper::Document
  key :name, String

  validates_uniqueness_of :name

  many :packages
end
