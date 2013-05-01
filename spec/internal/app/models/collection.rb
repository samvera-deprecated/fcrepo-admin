class Collection < ActiveFedora::Base

  has_metadata :name => "descMetadata", :type => ActiveFedora::QualifiedDublinCoreDatastream
  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata

  delegate :title, :to => "descMetadata", :unique => true

  belongs_to :admin_policy, :property => :is_governed_by
  has_many :members, :property => :is_member_of_collection, :inbound => true, :class_name => "ContentModel"

  include Hydra::ModelMixins::RightsMetadata
  include ActiveFedora::Auditable

end
