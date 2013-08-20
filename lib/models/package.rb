class Package
  include Mongoid::Document
  store_in collection: :packages
  field :name, type: String
  field :version, type: String

  belongs_to :package_system
  has_many :project_packages
end
