class PackageSystem
  include MongoMapper::Document
  key :name, String

  many :packages
end
