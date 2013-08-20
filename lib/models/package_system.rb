class PackageSystem
  include Mongoid::Document
  field :name, type: String
  store_in collection: :package_systems

  #validates_uniqueness_of :name

  has_many :packages
end
