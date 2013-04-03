class FcrepoObject < ActiveFedora::Base
  include DulHydra::Models::Auditable
  belongs_to :admin_policy, :property => :is_governed_by
  has_metadata :name => "descMetadata", :type => ActiveFedora::QualifiedDublinCoreDatastream
  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata
  delegate_to "descMetadata", [:title]
end

FactoryGirl.define do

  factory :fcrepo_object do
    title "Test Object"

    trait :apo do
      admin_policy
    end

    factory :fcrepo_object_apo, :traits => [:apo]

  end

end
