class Part < ActiveFedora::Base

  has_metadata :name => "descMetadata", :type => ActiveFedora::QualifiedDublinCoreDatastream
  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata
  has_file_datastream :name => "content", :type => ActiveFedora::Datastream

  delegate :title, :to => "descMetadata", :unique => true

  belongs_to :admin_policy, :property => :is_governed_by
  belongs_to :container, :property => :is_part_of, :class_name => 'Item'

  include Hydra::ModelMixins::RightsMetadata
  include ActiveFedora::Auditable

end
